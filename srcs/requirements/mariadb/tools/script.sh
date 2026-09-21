#!/bin/bash
set -e

# 1. قراءة كلمات المرور من مسارات Docker Secrets
DB_PASS=$(cat /run/secrets/db_password)
ROOT_PASS=$(cat /run/secrets/db_root_password)

# 2. إنشاء مجلدات التشغيل وضبط الصلاحيات
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

# 3. التحقق من التهيئة لأول مرة
if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    echo "Initializing MariaDB for the first time..."

    # تثبيت ملفات النظام الأساسية
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null

    # تشغيل mysqld مؤقتاً في الخلفية مع تخطي التحقق من الصلاحيات
    mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
    pid="$!"

    # انتظار جاهزية السيرفر المؤقت
    until mariadb-admin ping --silent; do
        sleep 1
    done

    # تطبيق أوامر التهيئة عبر عميل mariadb الرسمي
    mariadb -u root << EOF
-- إنشاء قاعدة البيانات
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

-- إنشاء مستخدم ووردبريس ومنحه الصلاحيات
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'\%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

-- تغيير كلمة سر الـ root وحمايته
ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_PASS}';

-- تطبيق التغييرات
FLUSH PRIVILEGES;
EOF

    # إيقاف السيرفر المؤقت بعد الانتهاء من التهيئة
    kill -s TERM "$pid"
    wait "$pid"

    echo "Database setup completed successfully."
fi

# 4. تشغيل السيرفر الرئيسي كـ PID 1
exec mysqld_safe --user=mysql