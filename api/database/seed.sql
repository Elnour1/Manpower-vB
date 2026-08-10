-- Insert Default Department
INSERT INTO Departments (DepartmentID, DepartmentName, Description) 
VALUES (1, 'HDPE Pipe Department', 'High-Density Polyethylene Pipe Production Line');

-- Insert Initial System Settings
INSERT INTO SystemSettings (SettingKey, SettingValue, Description) VALUES
('FACTORY_NAME', 'Plastic Pipe Manufacturing Plant', 'Factory Name'),
('WEEK_START_DAY', 'Sunday', 'First day of the production week'),
('COMPANY_WORKERS_BASELINE', '20', 'Default baseline of company permanent workers'),
('CURRENT_OUTSOURCED_WORKERS', '35', 'Current contracted outsourced workers'),
('DAILY_OUTSOURCED_COST', '150', 'Cost per outsourced worker per shift/day'),
('ACTIVE_MACHINE_SLOTS', '12', 'Number of currently active machines out of 16');

-- Insert Stop Reasons Master
INSERT INTO StopReasons (Reason, Active) VALUES
('No Order', 1),
('Maintenance', 1),
('Material Shortage', 1),
('Power Failure', 1),
('Trial', 1),
('Quality Issue', 1),
('Changeover', 1),
('Holiday', 1),
('Other', 1);

-- Insert Machine Master Slots (M01 to M16)
INSERT INTO Machines (DepartmentID, MachineCode, MachineName, MachineGroup, IsActive, Notes) VALUES
(1, 'M01', 'Extrusion Line 01', 'HDPE Extrusion', 1, 'Active production line'),
(1, 'M02', 'Extrusion Line 02', 'HDPE Extrusion', 1, 'Active production line'),
(1, 'M03', 'Extrusion Line 03', 'HDPE Extrusion', 1, 'Active production line'),
(1, 'M04', 'Extrusion Line 04', 'HDPE Extrusion', 1, 'Active production line'),
(1, 'M05', 'Extrusion Line 05', 'HDPE Extrusion', 1, 'Active production line'),
(1, 'M06', 'Extrusion Line 06', 'HDPE Extrusion', 1, 'Active production line'),
(1, 'M07', 'Extrusion Line 07', 'HDPE Extrusion', 1, 'Active production line'),
(1, 'M08', 'Extrusion Line 08', 'HDPE Extrusion', 1, 'Active production line'),
(1, 'M09', 'Extrusion Line 09', 'HDPE Extrusion', 1, 'Active production line'),
(1, 'M10', 'Extrusion Line 10', 'HDPE Extrusion', 1, 'Active production line'),
(1, 'M11', 'Extrusion Line 11', 'HDPE Extrusion', 1, 'Active production line'),
(1, 'M12', 'Extrusion Line 12', 'HDPE Extrusion', 1, 'Active production line'),
(1, 'M13', 'Extrusion Line 13', 'HDPE Extrusion', 0, 'Inactive / Spare Slot'),
(1, 'M14', 'Extrusion Line 14', 'HDPE Extrusion', 0, 'Inactive / Spare Slot'),
(1, 'M15', 'Extrusion Line 15', 'HDPE Extrusion', 0, 'Inactive / Spare Slot'),
(1, 'M16', 'Extrusion Line 16', 'HDPE Extrusion', 0, 'Inactive / Spare Slot');

-- Insert Product Master with Standard Labor Requirements
INSERT INTO Products (DepartmentID, ProductCode, ProductName, ProductFamily, StandardWorkers, AllowOverride, Notes) VALUES
(1, 'P-50-HDPE', '50 mm HDPE Pipe', 'Standard HDPE', 3, 1, 'Standard 3 workers requirement'),
(1, 'P-32-TCOMM', '32 mm Telecom Duct', 'Telecom Duct', 2, 1, 'Standard 2 workers requirement'),
(1, 'P-SUB-DUCT', 'Sub Duct', 'Telecom Duct', 2, 1, 'Standard 2 workers requirement'),
(1, 'P-COD-JACK', 'COD Jacket', 'Corrugated Pipe', 4, 1, 'Heavy handling - 4 workers requirement');