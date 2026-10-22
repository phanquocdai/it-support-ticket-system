-- =============================================================================
-- Migration V1: Initial Schema for IT Support Ticket Management System
-- =============================================================================

-- 1. Users Table
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_users_email UNIQUE (email),
    CONSTRAINT chk_users_role CHECK (role IN ('CUSTOMER', 'SUPPORT_AGENT', 'ADMIN')),
    CONSTRAINT chk_users_status CHECK (status IN ('ACTIVE', 'INACTIVE', 'SUSPENDED'))
);

CREATE INDEX idx_users_role ON users (role);

-- 2. Tickets Table
CREATE TABLE tickets (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    status VARCHAR(30) NOT NULL,
    priority VARCHAR(20) NOT NULL,
    category VARCHAR(50) NOT NULL,
    created_by_id BIGINT NOT NULL,
    assigned_to_id BIGINT NULL,
    version BIGINT NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_tickets_created_by FOREIGN KEY (created_by_id) REFERENCES users (id) ON DELETE RESTRICT,
    CONSTRAINT fk_tickets_assigned_to FOREIGN KEY (assigned_to_id) REFERENCES users (id) ON DELETE SET NULL,
    CONSTRAINT chk_tickets_status CHECK (status IN ('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED', 'CANCELLED')),
    CONSTRAINT chk_tickets_priority CHECK (priority IN ('LOW', 'MEDIUM', 'HIGH', 'URGENT')),
    CONSTRAINT chk_tickets_category CHECK (category IN ('HARDWARE', 'SOFTWARE', 'NETWORK', 'ACCESS', 'OTHER'))
);

CREATE INDEX idx_tickets_status ON tickets (status);
CREATE INDEX idx_tickets_created_by ON tickets (created_by_id);
CREATE INDEX idx_tickets_assigned_to ON tickets (assigned_to_id);
CREATE INDEX idx_tickets_priority ON tickets (priority);
CREATE INDEX idx_tickets_category ON tickets (category);
CREATE INDEX idx_tickets_created_at ON tickets (created_at DESC);
