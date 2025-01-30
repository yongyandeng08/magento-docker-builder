# Magento Docker Builder

This repository provides a **lightweight setup** for running **Adobe Commerce (Magento) Enterprise Edition** in a **Dockerized environment**. Instead of storing the entire Magento codebase, this repo keeps **only the essential configuration files**, allowing you to install all necessary dependencies on demand.

---

## **📌 Prerequisites**

Ensure you have the following installed on your system:

-   [Docker](https://docs.docker.com/get-docker/)
-   [Docker Compose](https://docs.docker.com/compose/install/)
-   [Composer](https://getcomposer.org/download/)
-   Magento **authentication keys** (for Adobe Commerce Enterprise Edition)

---

## **🚀 Installation Steps**

Follow these steps to set up Magento Cloud Docker on your local machine.

### **1️⃣ Clone the Repository**

```sh
git clone <your-repo-url> magento-docker-builder
cd magento-docker-builder
```

### **2️⃣ Install Magento Dependencies**

Run the following command to install all necessary packages:

```sh
composer install
```

This will create the `vendor/` directory and download all Magento dependencies.

### **3️⃣ Generate Docker Configuration**

Magento Cloud Docker requires Docker configuration files to be generated. Run:

```sh
./vendor/bin/ece-docker build:compose --mode="developer"
```

This will generate default the `docker-compose.yml` and other required config files.

### **4️⃣ Start Docker Services**

Now, run:

```sh
docker compose up -d
```

This will start the required **database, web server, FPM, OpenSearch, Redis, and other services** in detached mode.

Magento will be installed in a few seconds after `magento-fpm` is fully initialized.

### **5️⃣ Verify Running Containers**

Check if all services are running:

```sh
docker ps
```

You should see multiple containers running, including **MariaDB, Redis, OpenSearch, and Magento services**.

---

## **🔧 Additional Commands**

### **Stop Services**

```sh
docker compose down
```

This stops and removes all running containers.

### **Rebuild Containers (After Config Changes)**

If you make changes to the `docker-compose.override.yml`, run:

```sh
docker compose up -d --build
```

### **Access Magento in Browser**

Once the setup is complete, open:

```
http://localhost/admin
```

Use the credentials you provided during installation.

---

## **📌 Notes**

-   `magento-fpm` is the container
-   If you encounter **missing static files (e.g., `static.php` 404 errors)**, ensure you have run:
    ```sh
    ./vendor/bin/ece-docker build:compose --mode="developer"
    ```
-   Magento **authentication keys** may be required when installing enterprise dependencies.
-   `magento-fpm` is the PHP process manager that runs Magento's PHP code. If you need to check logs or debug issues, you can inspect the FPM container logs.
-   Always make changes to `docker-compose.override.yml`, as `docker-compose.yml` is auto-generated and may be overwritten.
