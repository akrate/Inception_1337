<?php
/**
 * phpMyAdmin configuration for Inception project
 */

$cfg['LoginCookieValidity'] = 14400; // 4 hours
$cfg['AllowThirdPartyFraming'] = false;
$cfg['SendErrorReports'] = 'never';
$cfg['ShowPhpInfo'] = false;
$cfg['ShowChgPassword'] = false;
$cfg['ShowCreateDb'] = false;

// Enable more secure defaults
$cfg['Servers'][1]['auth_type'] = 'cookie';
$cfg['Servers'][1]['host'] = 'mariadb';
$cfg['Servers'][1]['port'] = '3306';
$cfg['Servers'][1]['compress'] = false;
$cfg['Servers'][1]['AllowNoPassword'] = false;

// UI customization
$cfg['ThemeManager'] = true;
$cfg['ThemeDefault'] = 'pmahomme';
$cfg['FontSize'] = '82%';

// Security settings
$cfg['ForceSSL'] = true;
$cfg['AllowArbitraryServer'] = false;
$cfg['Servers'][1]['AllowRoot'] = false;
$cfg['Servers'][1]['AllowDeny']['order'] = 'deny,allow';
$cfg['Servers'][1]['AllowDeny']['rules'] = array();

// Performance settings
$cfg['QueryHistoryDB'] = true;
$cfg['QueryHistoryMax'] = 100;
$cfg['MaxDbList'] = 50;
$cfg['MaxTableList'] = 250;

// Feature toggles
$cfg['ShowServerInfo'] = true;
$cfg['ShowDbStructureCreation'] = true;
$cfg['ShowDbStructureCharset'] = false;
$cfg['ShowDbStructureComment'] = true;

// Set custom error reporting
error_reporting(E_ALL & ~E_NOTICE & ~E_DEPRECATED & ~E_STRICT);
ini_set('display_errors', '0');

// Add custom CSS for theming
$cfg['CSP'] = true;
$cfg['CSPAllow'] = array(
    'https://fonts.googleapis.com',
    'https://fonts.gstatic.com',
    'https://cdnjs.cloudflare.com'
);

// Enable additional features for development
if (isset($_ENV['DEVELOPMENT']) && $_ENV['DEVELOPMENT'] === 'true') {
    $cfg['ShowPhpInfo'] = true;
    $cfg['SendErrorReports'] = 'ask';
    error_reporting(E_ALL);
    ini_set('display_errors', '1');
}

// Language settings
$cfg['DefaultLang'] = 'en';
$cfg['DefaultConnectionCollation'] = 'utf8mb4_unicode_ci';

// Upload settings
$cfg['UploadDir'] = '';
$cfg['SaveDir'] = '';
$cfg['TempDir'] = '/tmp';

// Navigation panel settings
$cfg['NavigationWidth'] = 240;
$cfg['NavigationLinkWithMainPanel'] = true;
$cfg['NavigationTreeEnableGrouping'] = true;
$cfg['NavigationTreeDbSeparator'] = '_';
$cfg['NavigationTreeTableSeparator'] = '__';

// SQL query box settings
$cfg['SQLQuery']['Edit'] = true;
$cfg['SQLQuery']['Explain'] = true;
$cfg['SQLQuery']['ShowAsPHP'] = true;
$cfg['SQLQuery']['Refresh'] = true;

// Developer settings
$cfg['Developer'] = array(
    'mysql' => array(
        'develop' => false,
        'verbose' => false,
        'pma_verbose' => 'PHPMYADMIN',
        'pma_extension' => 'mysqli',
        'pma_display' => 'PMA_mysql',
        'pma_controluser' => 'pma',
        'pma_controlpass' => '',
        'pma_verbose_name' => 'verbose'
    )
);

// End of configuration
?>