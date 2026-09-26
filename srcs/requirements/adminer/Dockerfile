FROM adminer:latest

# Create custom adminer login plugin
RUN echo '<?php function adminer_object() {
    class AdminerSoftware extends Adminer {
        function loginForm() {
            global $drivers;
            echo "<table cellspacing=\'0\' class=\'layout\'>\n";
            echo "<tr><th>System:</th><td><select name=\'auth[driver]\'>";
            foreach ($drivers as $driver => $name) {
                echo "<option value=\"$driver\"" . (isset($_GET["$driver"]) ? " selected" : "") . ">$name</option>";
            }
            echo "</select></td></tr>\n";
            echo "<tr><th>Server:</th><td><input name=\'auth[server]\' value=\"" . h($_GET["host"] ?? "mariadb") . "\" title=\"hostname[:port]\"></td></tr>\n";
            echo "<tr><th>Username:</th><td><input name=\'auth[username]\' id=\"username\" value=\"" . h($_GET["username"] ?? "") . "\"></td></tr>\n";
            echo "<tr><th>Password:</th><td><input type=\"password\" name=\'auth[password]\'></td></tr>\n";
            echo "<tr><th>Database:</th><td><input name=\'auth[db]\' value=\"" . h($_GET["db"] ?? "wordpress") . "\"></td></tr>\n";
            echo "</table>\n";
            echo "<p><input type=\"submit\" value=\"Login\">\n";
            echo "<input type=\"hidden\" name=\'auth[permanent]\' value=\"1\">\n";
        }
    }
    return new AdminerSoftware;
}' > /var/www/html/plugins/plugin.php

# Copy custom configuration
COPY conf/adminer.css /var/www/html/adminer.css