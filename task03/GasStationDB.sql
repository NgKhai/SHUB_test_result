use master
if exists (select * from sysdatabases where name = 'GasStationDB')
drop database GasStationDB
go
create database GasStationDB
go
use GasStationDB

-- Stations
CREATE TABLE Stations (
    station_id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(255) NOT NULL,
    location NVARCHAR(255),
    contact_info NVARCHAR(255),
    manager_name NVARCHAR(255),
    opening_hours NVARCHAR(50),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- Products
CREATE TABLE Products (
    product_id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(255) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    description NVARCHAR(MAX),
    category NVARCHAR(50),
    stock_quantity INT,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- Pumps
CREATE TABLE Pumps (
    pump_id INT PRIMARY KEY IDENTITY(1,1),
    station_id INT NOT NULL,
    product_id INT NOT NULL,
    status NVARCHAR(50) DEFAULT 'active',
    installation_date DATE,
    last_service_date DATE,
    model NVARCHAR(255),
    max_capacity DECIMAL(10, 2),  -- Công suất tối đa của trụ bơm
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (station_id) REFERENCES Stations(station_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Transactions
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY IDENTITY(1,1),
    transaction_time DATETIME NOT NULL,
    station_id INT NOT NULL,
    pump_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity DECIMAL(10, 2) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    payment_method NVARCHAR(50),
    customer_id INT,
    notes NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (station_id) REFERENCES Stations(station_id),
    FOREIGN KEY (pump_id) REFERENCES Pumps(pump_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Indexes
CREATE INDEX idx_station_id ON Pumps (station_id);
CREATE INDEX idx_product_id ON Pumps (product_id);
CREATE INDEX idx_transaction_station ON Transactions (station_id);
CREATE INDEX idx_transaction_pump ON Transactions (pump_id);
CREATE INDEX idx_transaction_product ON Transactions (product_id);

-- VALUE --

-- Stations
INSERT INTO Stations (name, location, contact_info, manager_name, opening_hours)
VALUES 
(N'Trạm xăng A', N'156 Trường Chinh, HCMC', N'0906234567', N'Nguyễn Văn A', N'06:00-22:00'),
(N'Trạm xăng B', N'25 Trần Quốc Toản, HCMC', N'0272345678', N'Lê Thị B', N'07:00-23:00'),
(N'Trạm xăng C', N'789 Đường Lê Lai, HCMC', N'0753456789', N'Phạm Minh C', N'05:30-21:30');

-- Products
INSERT INTO Products (name, unit_price, description, category, stock_quantity)
VALUES 
(N'xăng A95', 23.00, N'Xăng A95', N'xăng', 1000),
(N'xăng E5', 21.50, N'Xăng E5', N'xăng', 1500),
(N'dầu DO', 19.00, N'Dầu diesel DO', N'dầu', 800);

-- Pumps
INSERT INTO Pumps (station_id, product_id, status, installation_date, model, max_capacity)
VALUES 
(1, 1, N'Đang hoạt động', '2024-01-10', N'Trạm A', 1000.00),
(1, 2, N'Đang hoạt động', '2024-01-12', N'Trạm B', 800.00),
(2, 3, N'Bảo trì', '2023-12-15', N'Trạm C', 750.00),
(3, 1, N'Đang hoạt động', '2024-01-05', N'Trạm D', 900.00);

-- Transactions
INSERT INTO Transactions (transaction_time, station_id, pump_id, product_id, quantity, unit_price, total_amount, payment_method, customer_id, notes)
VALUES 
('2024-10-01 08:30:00', 1, 1, 1, 50.00, 23.00, 1150.00, N'tiền mặt', 1, N'N/A'),
('2024-10-01 09:00:00', 1, 2, 2, 30.00, 21.50, 645.00, N'thẻ tín dụng', 2, N'Khách hàng thân thiết'),
('2024-10-02 10:15:00', 2, 3, 3, 40.00, 19.00, 760.00, N'thẻ ghi nợ', 3, N'Giao dịch đầu tiên');

SELECT * FROM Stations
SELECT * FROM Products
SELECT * FROM Pumps
SELECT * FROM Transactions
