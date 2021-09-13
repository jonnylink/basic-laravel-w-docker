server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /srv/user.mobilefuse.com/public;
    index index.php index.htm index.html;

    server_name user.mobilefuse.com;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location /index.php {
        include fastcgi_params;
        fastcgi_connect_timeout 10s;
        fastcgi_read_timeout 10s;
        fastcgi_buffers 256 4k;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_pass unix:/run/php-fpm.sock;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
}