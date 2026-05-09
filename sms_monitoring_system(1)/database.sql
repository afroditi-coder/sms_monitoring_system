-- SMS/Viber Remote Server Monitoring System Database

CREATE TABLE Servers (
    server_id SERIAL PRIMARY KEY,
    hostname VARCHAR(100) NOT NULL,
    ip_address VARCHAR(50) UNIQUE NOT NULL,
    location VARCHAR(100),
    status VARCHAR(20) DEFAULT 'active'
);

CREATE TABLE Metrics (
    metric_id BIGSERIAL PRIMARY KEY,
    server_id INT REFERENCES Servers(server_id),
    metric_type VARCHAR(50),
    value FLOAT,
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE AlertRules (
    rule_id SERIAL PRIMARY KEY,
    metric_type VARCHAR(50),
    threshold_value FLOAT,
    condition VARCHAR(5),
    severity VARCHAR(20)
);

CREATE TABLE Alerts (
    alert_id SERIAL PRIMARY KEY,
    server_id INT REFERENCES Servers(server_id),
    rule_id INT REFERENCES AlertRules(rule_id),
    triggered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'active'
);

CREATE TABLE Contacts (
    contact_id INT PRIMARY KEY,
    name VARCHAR(100),
    phone_number VARCHAR(20),
    viber_id VARCHAR(50)
);

CREATE TABLE Notifications (
    notification_id SERIAL PRIMARY KEY,
    alert_id INT REFERENCES Alerts(alert_id),
    contact_id INT,
    channel VARCHAR(10),
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20)
);

-- Mock Data

INSERT INTO Servers (hostname, ip_address, location)
VALUES ('Server-1', '192.168.1.1', 'Athens');

INSERT INTO AlertRules (metric_type, threshold_value, condition, severity)
VALUES ('CPU', 90, '>', 'critical');

INSERT INTO Metrics (server_id, metric_type, value)
VALUES (1, 'CPU', 95);

INSERT INTO Alerts (server_id, rule_id)
VALUES (1, 1);

INSERT INTO Contacts VALUES (1, 'Admin User', '+306999999999', 'viber123');

INSERT INTO Notifications (alert_id, contact_id, channel, status)
VALUES (1, 1, 'SMS', 'sent');
