@echo off
REM Environment Setup Script for Microservices College Management System (Windows)
REM This script sets up the complete development environment using Docker

REM Enable ANSI color support in Windows Command Prompt
reg add HKEY_CURRENT_USER\Console /v VirtualTerminalLevel /t REG_DWORD /d 0x00000001 /f >nul 2>&1

setlocal enabledelayedexpansion

REM Jump to main execution to avoid running functions sequentially
goto :main

REM Function to print colored output using PowerShell
:print_status
set "msg=%*"
powershell -Command "Write-Host '[INFO] %msg%' -ForegroundColor Green"
goto :eof

:print_warning
set "msg=%*"
powershell -Command "Write-Host '[WARNING] %msg%' -ForegroundColor Yellow"
goto :eof

:print_error
set "msg=%*"
powershell -Command "Write-Host '[ERROR] %msg%' -ForegroundColor Red"
goto :eof

:print_header
set "msg=%*"
echo.
powershell -Command "Write-Host '=== %msg% ===' -ForegroundColor Cyan"
goto :eof

REM Check if Docker is installed and running
:check_docker
call :print_header "Checking Docker Installation"

docker --version >nul 2>&1
if errorlevel 1 (
    call :print_error "Docker is not installed. Please install Docker Desktop first."
    exit /b 1
)

docker info >nul 2>&1
if errorlevel 1 (
    call :print_error "Docker is not running. Please start Docker Desktop."
    exit /b 1
)

call :print_status "Docker is installed and running"
docker --version
docker compose version
goto :eof

REM Check system resources
:check_resources
call :print_header "Checking System Resources"

REM Get total physical memory in GB (approximate)
for /f "tokens=2 delims==" %%a in ('wmic computersystem get TotalPhysicalMemory /value') do set TOTAL_MEM_BYTES=%%a
set /a TOTAL_MEM_GB=%TOTAL_MEM_BYTES:~0,-9%

if %TOTAL_MEM_GB% lss 8 (
    call :print_warning "System has less than 8GB RAM. Some services might run slowly."
) else (
    call :print_status "System memory: %TOTAL_MEM_GB%GB"
)

REM Check available disk space (approximate)
for /f "tokens=3" %%a in ('dir /-c ^| find "bytes free"') do set AVAILABLE_SPACE=%%a
set AVAILABLE_SPACE=%AVAILABLE_SPACE:,=%
set /a AVAILABLE_GB=%AVAILABLE_SPACE:~0,-9%

if %AVAILABLE_GB% lss 5 (
    call :print_warning "Available disk space is less than 5GB. Consider freeing up space."
) else (
    call :print_status "Available disk space: %AVAILABLE_GB%GB"
)
goto :eof

REM Pull required Docker images
:pull_images
call :print_header "Pulling Required Docker Images"

set images=postgres:15-alpine elasticsearch:8.9.0 kibana:8.9.0 redis:7-alpine dpage/pgadmin4:latest nginx:alpine openjdk:17-jdk-slim prom/prometheus:latest grafana/grafana:latest

for %%i in (%images%) do (
    call :print_status "Pulling %%i..."
    docker pull %%i
    if errorlevel 1 (
        call :print_error "Failed to pull %%i"
        exit /b 1
    )
)

call :print_status "All images pulled successfully"
goto :eof

REM Create required directories
:create_directories
call :print_header "Creating Project Directory Structure"

set directories=docker-config\postgres docker-config\pgadmin docker-config\prometheus docker-config\grafana\dashboards docker-config\grafana\datasources nginx\conf.d student-service faculty-service search-service scripts docs

for %%d in (%directories%) do (
    if not exist "%%d" (
        mkdir "%%d"
        call :print_status "Created directory: %%d"
    )
)
goto :eof

REM Setup configuration files
:setup_configs
call :print_header "Setting Up Configuration Files"

REM Create nginx configuration
if not exist "nginx\nginx.conf" (
    (
        echo events {
        echo     worker_connections 1024;
        echo }
        echo.
        echo http {
        echo     upstream student-service {
        echo         server student-service:8081;
        echo     }
        echo.
        echo     upstream faculty-service {
        echo         server faculty-service:8082;
        echo     }
        echo.
        echo     upstream search-service {
        echo         server search-service:8083;
        echo     }
        echo.
        echo     server {
        echo         listen 80;
        echo         server_name localhost;
        echo.
        echo         # Student Service Routes
        echo         location /api/students/ {
        echo             proxy_pass http://student-service/;
        echo             proxy_set_header Host $host;
        echo             proxy_set_header X-Real-IP $remote_addr;
        echo             proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        echo         }
        echo.
        echo         # Faculty Service Routes
        echo         location /api/faculty/ {
        echo             proxy_pass http://faculty-service/;
        echo             proxy_set_header Host $host;
        echo             proxy_set_header X-Real-IP $remote_addr;
        echo             proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        echo         }
        echo.
        echo         # Search Service Routes
        echo         location /api/search/ {
        echo             proxy_pass http://search-service/;
        echo             proxy_set_header Host $host;
        echo             proxy_set_header X-Real-IP $remote_addr;
        echo             proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        echo         }
        echo.
        echo         # Health Check Endpoints
        echo         location /health/students {
        echo             proxy_pass http://student-service/actuator/health;
        echo         }
        echo.
        echo         location /health/faculty {
        echo             proxy_pass http://faculty-service/actuator/health;
        echo         }
        echo.
        echo         location /health/search {
        echo             proxy_pass http://search-service/actuator/health;
        echo         }
        echo     }
        echo }
    ) > nginx\nginx.conf
    call :print_status "Created nginx.conf"
)

REM Create pgAdmin servers configuration
if not exist "docker-config\pgadmin\servers.json" (
    (
        echo {
        echo     "Servers": {
        echo         "1": {
        echo             "Name": "Student Database",
        echo             "Group": "Microservices",
        echo             "Host": "postgres-student",
        echo             "Port": 5432,
        echo             "MaintenanceDB": "student_db",
        echo             "Username": "student_user",
        echo             "SSLMode": "prefer"
        echo         },
        echo         "2": {
        echo             "Name": "Faculty Database",
        echo             "Group": "Microservices",
        echo             "Host": "postgres-faculty",
        echo             "Port": 5432,
        echo             "MaintenanceDB": "faculty_db",
        echo             "Username": "faculty_user",
        echo             "SSLMode": "prefer"
        echo         }
        echo     }
        echo }
    ) > docker-config\pgadmin\servers.json
    call :print_status "Created pgAdmin servers.json"
)

REM Create Prometheus configuration
if not exist "docker-config\prometheus\prometheus.yml" (
    (
        echo global:
        echo   scrape_interval: 15s
        echo   evaluation_interval: 15s
        echo.
        echo scrape_configs:
        echo   - job_name: 'prometheus'
        echo     static_configs:
        echo       - targets: ['localhost:9090']
        echo.
        echo   - job_name: 'student-service'
        echo     static_configs:
        echo       - targets: ['student-service:8081']
        echo     metrics_path: '/actuator/prometheus'
        echo.
        echo   - job_name: 'faculty-service'
        echo     static_configs:
        echo       - targets: ['faculty-service:8082']
        echo     metrics_path: '/actuator/prometheus'
        echo.
        echo   - job_name: 'search-service'
        echo     static_configs:
        echo       - targets: ['search-service:8083']
        echo     metrics_path: '/actuator/prometheus'
    ) > docker-config\prometheus\prometheus.yml
    call :print_status "Created prometheus.yml"
)
goto :eof

REM Start the environment
:start_environment
call :print_header "Starting Development Environment"

call :print_status "Starting core infrastructure services..."
docker compose up -d postgres-student postgres-faculty elasticsearch redis
if errorlevel 1 (
    call :print_error "Failed to start core services"
    exit /b 1
)

call :print_status "Waiting for databases to be ready..."
timeout /t 30 /nobreak >nul

call :print_status "Starting management and monitoring tools..."
docker compose up -d pgadmin prometheus grafana
if errorlevel 1 (
    call :print_error "Failed to start management tools"
    exit /b 1
)

call :print_status "Starting Kibana..."
docker compose up -d kibana
if errorlevel 1 (
    call :print_error "Failed to start Kibana"
    exit /b 1
)

call :print_status "Core environment started successfully!"
goto :eof

REM Verify services
:verify_services
call :print_header "Verifying Services"

call :print_status "Checking container status..."
docker compose ps

call :print_status "Testing database connections..."

REM Test student database
docker exec postgres-student pg_isready -U student_user -d student_db >nul 2>&1
if errorlevel 1 (
    call :print_error "Student database: FAILED"
) else (
    call :print_status "Student database: OK"
)

REM Test faculty database
docker exec postgres-faculty pg_isready -U faculty_user -d faculty_db >nul 2>&1
if errorlevel 1 (
    call :print_error "Faculty database: FAILED"
) else (
    call :print_status "Faculty database: OK"
)

call :print_status "Testing Elasticsearch..."
timeout /t 10 /nobreak >nul
curl -s http://localhost:9200/_cluster/health >nul 2>&1
if errorlevel 1 (
    call :print_warning "Elasticsearch: Still starting... (this may take a few minutes)"
) else (
    call :print_status "Elasticsearch: OK"
)

REM Test Redis
docker exec redis redis-cli ping >nul 2>&1
if errorlevel 1 (
    call :print_error "Redis: FAILED"
) else (
    call :print_status "Redis: OK"
)
goto :eof

REM Display access information
:show_access_info
call :print_header "Service Access Information"

echo.
powershell -Command "Write-Host 'Database Services:' -ForegroundColor Cyan"
echo   PostgreSQL (Student): localhost:5432
echo     Database: student_db
echo     Username: student_user
echo     Password: student_pass
echo.
echo   PostgreSQL (Faculty): localhost:5433
echo     Database: faculty_db
echo     Username: faculty_user
echo     Password: faculty_pass
echo.
powershell -Command "Write-Host 'Search and Cache:' -ForegroundColor Cyan"
echo   Elasticsearch: http://localhost:9200
echo   Kibana: http://localhost:5601
echo   Redis: localhost:6379
echo.
powershell -Command "Write-Host 'Management Tools:' -ForegroundColor Cyan"
echo   pgAdmin: http://localhost:5050
echo     Email: admin@admin.com
echo     Password: admin123
echo.
powershell -Command "Write-Host 'Monitoring:' -ForegroundColor Cyan"
echo   Prometheus: http://localhost:9090
echo   Grafana: http://localhost:3000
echo     Username: admin
echo     Password: admin123
echo.
powershell -Command "Write-Host 'API Gateway (when services are ready):' -ForegroundColor Cyan"
echo   NGINX: http://localhost:80
echo.
goto :eof

REM =============================================
REM MAIN EXECUTION FUNCTION
REM =============================================
:main
call :print_header "Microservices Environment Setup"

call :check_docker
if errorlevel 1 exit /b 1

call :check_resources
call :create_directories
call :setup_configs
call :pull_images
if errorlevel 1 exit /b 1

call :start_environment
if errorlevel 1 exit /b 1

call :verify_services
call :show_access_info

call :print_header "Setup Complete!"
call :print_status "Your development environment is ready!"
call :print_status "Next steps:"
echo   1. Create your Spring Boot microservices
echo   2. Configure application.yml files with database connections
echo   3. Build and run your services
echo   4. Access the management tools using the URLs above
echo.
call :print_status "To stop all services: docker compose down"
call :print_status "To start services again: docker compose up -d"

pause
exit /b 0