#!/bin/bash
yum -y update
yum -y install httpd
systemctl enable --now httpd
systemctl restart httpd
cat<<EOF>/var/www/html/index.html
<!DOCTYPE html>
    <html lang="en">
        <head>
            <meta charset="utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            <title>xlifex</title>
            <link rel="preconnect" href="https://fonts.googleapis.com" />
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
            <link
                href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700;800&display=swap"
                rel="stylesheet"
            />
            <link rel="stylesheet" href="css/styles.css?v=1.0" />
        </head>
        <body>
            <div class="wrapper">
                <div class="container">
                    <h1>Welcome! An Apache web server has been started successfully.</h1>
                    <form action="userdata.php" method="get">
                    Name: <input type="text" name="name"><br>
                    E-mail: <input type="text" name="email"><br>
                    <input type="submit">
                    </form>
                    <h2>Yejin Hong</h2>
                </div>
            </div>
        </body>
    </html>
    <style>
        body {
            background-color: #34333d;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: Inter;
            padding-top: 128px;
        }
        .container {
            box-sizing: border-box;
            width: 741px;
            height: 449px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: flex-start;
            padding: 48px 48px 48px 48px;
            box-shadow: 0px 1px 32px 11px rgba(38, 37, 44, 0.49);
            background-color: #5d5b6b;
            overflow: hidden;
            align-content: flex-start;
            flex-wrap: nowrap;
            gap: 24;
            border-radius: 24px;
        }
        .container h1 {
            flex-shrink: 0;
            width: 100%;
            height: auto; /* 144px */
            position: relative;
            color: #ffffff;
            line-height: 1.2;
            font-size: 40px;
        }
        .container p {
            position: relative;
            color: #ffffff;
            line-height: 1.2;
            font-size: 18px;
        }
    </style>
EOF