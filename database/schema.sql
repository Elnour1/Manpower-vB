PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS Departments (
    DepartmentID INTEGER PRIMARY KEY AUTOINCREMENT,
    DepartmentName TEXT NOT NULL UNIQUE,
    Description TEXT
);

CREATE TABLE IF NOT EXISTS Machines (
    MachineID INTEGER PRIMARY KEY AUTOINCREMENT,
    DepartmentID INTEGER NOT NULL,
    MachineCode TEXT NOT NULL UNIQUE,
    MachineName TEXT NOT NULL,
    MachineGroup TEXT,
    IsActive INTEGER DEFAULT 1 CHECK (IsActive IN (0, 1)),
    Notes TEXT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE IF NOT EXISTS Products (
    ProductID INTEGER PRIMARY KEY AUTOINCREMENT,
    DepartmentID INTEGER NOT NULL,
    ProductCode TEXT NOT NULL UNIQUE,
    ProductName TEXT NOT NULL,
    ProductFamily TEXT,
    StandardWorkers INTEGER NOT NULL CHECK (StandardWorkers >= 0),
    AllowOverride INTEGER DEFAULT 1 CHECK (AllowOverride IN (0, 1)),
    Notes TEXT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE IF NOT EXISTS StopReasons (
    StopReasonID INTEGER PRIMARY KEY AUTOINCREMENT,
    Reason TEXT NOT NULL UNIQUE,
    Active INTEGER DEFAULT 1 CHECK (Active IN (0, 1))
);

CREATE TABLE IF NOT EXISTS PlanningWeeks (
    WeekID INTEGER PRIMARY KEY AUTOINCREMENT,
    WeekNumber INTEGER NOT NULL,
    Year INTEGER NOT NULL,
    WeekStart DATE NOT NULL,
    WeekEnd DATE NOT NULL,
    Status TEXT DEFAULT 'Active' CHECK (Status IN ('Active', 'Archived', 'Locked')),
    CreatedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(WeekNumber, Year)
);

CREATE TABLE IF NOT EXISTS PlanningShifts (
    ShiftID INTEGER PRIMARY KEY AUTOINCREMENT,
    WeekID INTEGER NOT NULL,
    Date DATE NOT NULL,
    Shift TEXT NOT NULL CHECK (Shift IN ('Day', 'Night')),
    ShiftTime TEXT CHECK (ShiftTime IN ('07:00-19:00', '19:00-07:00')),
    FOREIGN KEY (WeekID) REFERENCES PlanningWeeks(WeekID),
    UNIQUE(Date, Shift)
);

CREATE TABLE IF NOT EXISTS MachinePlanning (
    PlanningID INTEGER PRIMARY KEY AUTOINCREMENT,
    ShiftID INTEGER NOT NULL,
    MachineID INTEGER NOT NULL,
    Status TEXT NOT NULL CHECK (Status IN ('Running', 'Stopped', 'Maintenance', 'Trial')),
    ProductID INTEGER,
    CalculatedWorkers INTEGER DEFAULT 0,
    ManualOverride INTEGER,
    FinalWorkers INTEGER NOT NULL,
    StopReasonID INTEGER,
    Notes TEXT,
    FOREIGN KEY (ShiftID) REFERENCES PlanningShifts(ShiftID),
    FOREIGN KEY (MachineID) REFERENCES Machines(MachineID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (StopReasonID) REFERENCES StopReasons(StopReasonID),
    UNIQUE(ShiftID, MachineID)
);

CREATE TABLE IF NOT EXISTS ActualOperation (
    ActualID INTEGER PRIMARY KEY AUTOINCREMENT,
    ShiftID INTEGER NOT NULL,
    MachineID INTEGER NOT NULL,
    Status TEXT NOT NULL CHECK (Status IN ('Running', 'Stopped', 'Maintenance', 'Trial')),
    ProductID INTEGER,
    ActualWorkers INTEGER NOT NULL CHECK (ActualWorkers >= 0),
    StopReasonID INTEGER,
    Notes TEXT,
    FOREIGN KEY (ShiftID) REFERENCES PlanningShifts(ShiftID),
    FOREIGN KEY (MachineID) REFERENCES Machines(MachineID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (StopReasonID) REFERENCES StopReasons(StopReasonID),
    UNIQUE(ShiftID, MachineID)
);

CREATE TABLE IF NOT EXISTS CompanyLabor (
    RecordID INTEGER PRIMARY KEY AUTOINCREMENT,
    ShiftID INTEGER NOT NULL UNIQUE,
    CompanyWorkers INTEGER NOT NULL CHECK (CompanyWorkers >= 0),
    FOREIGN KEY (ShiftID) REFERENCES PlanningShifts(ShiftID)
);

CREATE TABLE IF NOT EXISTS ExternalLabor (
    RecordID INTEGER PRIMARY KEY AUTOINCREMENT,
    ShiftID INTEGER NOT NULL UNIQUE,
    ExternalWorkers INTEGER NOT NULL CHECK (ExternalWorkers >= 0),
    ApprovedWorkers INTEGER DEFAULT 0 CHECK (ApprovedWorkers >= 0),
    CurrentWorkers INTEGER DEFAULT 0 CHECK (CurrentWorkers >= 0),
    FOREIGN KEY (ShiftID) REFERENCES PlanningShifts(ShiftID)
);

CREATE TABLE IF NOT EXISTS SystemSettings (
    SettingKey TEXT PRIMARY KEY,
    SettingValue TEXT NOT NULL,
    Description TEXT
);

CREATE TABLE IF NOT EXISTS Users (
    UserID INTEGER PRIMARY KEY AUTOINCREMENT,
    FullName TEXT NOT NULL,
    Username TEXT NOT NULL UNIQUE,
    PasswordHash TEXT NOT NULL,
    Role TEXT NOT NULL CHECK (Role IN ('ProductionManager', 'HR', 'PlantManager', 'Admin')),
    DepartmentID INTEGER,
    Active INTEGER DEFAULT 1,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE IF NOT EXISTS AuditLog (
    LogID INTEGER PRIMARY KEY AUTOINCREMENT,
    UserID INTEGER,
    DateTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    Action TEXT NOT NULL,
    OldValue TEXT,
    NewValue TEXT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);