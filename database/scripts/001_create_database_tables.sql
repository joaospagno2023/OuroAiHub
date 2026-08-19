USE OuroAIHub;
GO


/* ============================================================
   DEPARTMENTS
   ============================================================ */

CREATE TABLE departments
(
    id INT IDENTITY(1,1) NOT NULL,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(500) NULL,
    is_active BIT NOT NULL
        CONSTRAINT DF_departments_is_active DEFAULT (1),
    created_at DATETIME2(0) NOT NULL
        CONSTRAINT DF_departments_created_at DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_departments
        PRIMARY KEY (id),

    CONSTRAINT UQ_departments_name
        UNIQUE (name)
);
GO


/* ============================================================
   USERS
   ============================================================ */

CREATE TABLE users
(
    id INT IDENTITY(1,1) NOT NULL,
    department_id INT NOT NULL,
    username NVARCHAR(100) NOT NULL,
    email NVARCHAR(255) NOT NULL,
    password_hash NVARCHAR(500) NOT NULL,
    full_name NVARCHAR(200) NOT NULL,
    is_active BIT NOT NULL
        CONSTRAINT DF_users_is_active DEFAULT (1),
    created_at DATETIME2(0) NOT NULL
        CONSTRAINT DF_users_created_at DEFAULT (SYSUTCDATETIME()),
    updated_at DATETIME2(0) NULL,

    CONSTRAINT PK_users
        PRIMARY KEY (id),

    CONSTRAINT UQ_users_username
        UNIQUE (username),

    CONSTRAINT UQ_users_email
        UNIQUE (email),

    CONSTRAINT FK_users_departments
        FOREIGN KEY (department_id)
        REFERENCES departments(id)
);
GO


CREATE INDEX IX_users_department_id
    ON users(department_id);
GO


/* ============================================================
   ROLES
   ============================================================ */

CREATE TABLE roles
(
    id INT IDENTITY(1,1) NOT NULL,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(500) NULL,
    is_active BIT NOT NULL
        CONSTRAINT DF_roles_is_active DEFAULT (1),

    CONSTRAINT PK_roles
        PRIMARY KEY (id),

    CONSTRAINT UQ_roles_name
        UNIQUE (name)
);
GO


/* ============================================================
   USER ROLES
   ============================================================ */

CREATE TABLE user_roles
(
    user_id INT NOT NULL,
    role_id INT NOT NULL,

    CONSTRAINT PK_user_roles
        PRIMARY KEY (user_id, role_id),

    CONSTRAINT FK_user_roles_users
        FOREIGN KEY (user_id)
        REFERENCES users(id),

    CONSTRAINT FK_user_roles_roles
        FOREIGN KEY (role_id)
        REFERENCES roles(id)
);
GO


/* ============================================================
   PERMISSIONS
   ============================================================ */

CREATE TABLE permissions
(
    id INT IDENTITY(1,1) NOT NULL,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(500) NULL,

    CONSTRAINT PK_permissions
        PRIMARY KEY (id),

    CONSTRAINT UQ_permissions_name
        UNIQUE (name)
);
GO


/* ============================================================
   ROLE PERMISSIONS
   ============================================================ */

CREATE TABLE role_permissions
(
    role_id INT NOT NULL,
    permission_id INT NOT NULL,

    CONSTRAINT PK_role_permissions
        PRIMARY KEY (role_id, permission_id),

    CONSTRAINT FK_role_permissions_roles
        FOREIGN KEY (role_id)
        REFERENCES roles(id),

    CONSTRAINT FK_role_permissions_permissions
        FOREIGN KEY (permission_id)
        REFERENCES permissions(id)
);
GO


/* ============================================================
   CATEGORIES
   ============================================================ */

CREATE TABLE categories
(
    id INT IDENTITY(1,1) NOT NULL,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(500) NULL,
    is_active BIT NOT NULL
        CONSTRAINT DF_categories_is_active DEFAULT (1),
    created_at DATETIME2(0) NOT NULL
        CONSTRAINT DF_categories_created_at DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_categories
        PRIMARY KEY (id),

    CONSTRAINT UQ_categories_name
        UNIQUE (name)
);
GO


/* ============================================================
   TEMPLATES
   ============================================================ */

CREATE TABLE templates
(
    id INT IDENTITY(1,1) NOT NULL,
    category_id INT NOT NULL,
    department_id INT NULL,
    name NVARCHAR(200) NOT NULL,
    slug NVARCHAR(250) NOT NULL,
    description NVARCHAR(MAX) NULL,
    template_type NVARCHAR(50) NOT NULL,
    visibility NVARCHAR(30) NOT NULL,
    author_user_id INT NOT NULL,
    current_version INT NOT NULL
        CONSTRAINT DF_templates_current_version DEFAULT (1),
    is_active BIT NOT NULL
        CONSTRAINT DF_templates_is_active DEFAULT (1),
    created_at DATETIME2(0) NOT NULL
        CONSTRAINT DF_templates_created_at DEFAULT (SYSUTCDATETIME()),
    updated_at DATETIME2(0) NULL,

    CONSTRAINT PK_templates
        PRIMARY KEY (id),

    CONSTRAINT UQ_templates_slug
        UNIQUE (slug),

    CONSTRAINT FK_templates_categories
        FOREIGN KEY (category_id)
        REFERENCES categories(id),

    CONSTRAINT FK_templates_departments
        FOREIGN KEY (department_id)
        REFERENCES departments(id),

    CONSTRAINT FK_templates_author
        FOREIGN KEY (author_user_id)
        REFERENCES users(id),

    CONSTRAINT CK_templates_type
        CHECK
        (
            template_type IN
            (
                'PROMPT',
                'N8N_WORKFLOW',
                'AI_AGENT',
                'SYSTEM_PROMPT',
                'USER_PROMPT',
                'AUTOMATION'
            )
        ),

    CONSTRAINT CK_templates_visibility
        CHECK
        (
            visibility IN
            (
                'PUBLIC',
                'DEPARTMENT',
                'PRIVATE'
            )
        )
);
GO


CREATE INDEX IX_templates_category_id
    ON templates(category_id);
GO


CREATE INDEX IX_templates_department_id
    ON templates(department_id);
GO


CREATE INDEX IX_templates_author_user_id
    ON templates(author_user_id);
GO


/* ============================================================
   TEMPLATE VERSIONS
   ============================================================ */

CREATE TABLE template_versions
(
    id INT IDENTITY(1,1) NOT NULL,
    template_id INT NOT NULL,
    version INT NOT NULL,
    title NVARCHAR(200) NULL,
    content NVARCHAR(MAX) NOT NULL,
    documentation NVARCHAR(MAX) NULL,
    change_description NVARCHAR(1000) NULL,
    created_by INT NOT NULL,
    created_at DATETIME2(0) NOT NULL
        CONSTRAINT DF_template_versions_created_at DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_template_versions
        PRIMARY KEY (id),

    CONSTRAINT UQ_template_versions
        UNIQUE (template_id, version),

    CONSTRAINT FK_template_versions_templates
        FOREIGN KEY (template_id)
        REFERENCES templates(id),

    CONSTRAINT FK_template_versions_users
        FOREIGN KEY (created_by)
        REFERENCES users(id)
);
GO


CREATE INDEX IX_template_versions_template_id
    ON template_versions(template_id);
GO


/* ============================================================
   TAGS
   ============================================================ */

CREATE TABLE tags
(
    id INT IDENTITY(1,1) NOT NULL,
    name NVARCHAR(100) NOT NULL,

    CONSTRAINT PK_tags
        PRIMARY KEY (id),

    CONSTRAINT UQ_tags_name
        UNIQUE (name)
);
GO


/* ============================================================
   TEMPLATE TAGS
   ============================================================ */

CREATE TABLE template_tags
(
    template_id INT NOT NULL,
    tag_id INT NOT NULL,

    CONSTRAINT PK_template_tags
        PRIMARY KEY (template_id, tag_id),

    CONSTRAINT FK_template_tags_templates
        FOREIGN KEY (template_id)
        REFERENCES templates(id),

    CONSTRAINT FK_template_tags_tags
        FOREIGN KEY (tag_id)
        REFERENCES tags(id)
);
GO


/* ============================================================
   FAVORITES
   ============================================================ */

CREATE TABLE favorites
(
    user_id INT NOT NULL,
    template_id INT NOT NULL,
    created_at DATETIME2(0) NOT NULL
        CONSTRAINT DF_favorites_created_at DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_favorites
        PRIMARY KEY (user_id, template_id),

    CONSTRAINT FK_favorites_users
        FOREIGN KEY (user_id)
        REFERENCES users(id),

    CONSTRAINT FK_favorites_templates
        FOREIGN KEY (template_id)
        REFERENCES templates(id)
);
GO


/* ============================================================
   DOWNLOADS
   ============================================================ */

CREATE TABLE downloads
(
    id BIGINT IDENTITY(1,1) NOT NULL,
    user_id INT NOT NULL,
    template_id INT NOT NULL,
    template_version_id INT NULL,
    downloaded_at DATETIME2(0) NOT NULL
        CONSTRAINT DF_downloads_downloaded_at DEFAULT (SYSUTCDATETIME()),

    CONSTRAINT PK_downloads
        PRIMARY KEY (id),

    CONSTRAINT FK_downloads_users
        FOREIGN KEY (user_id)
        REFERENCES users(id),

    CONSTRAINT FK_downloads_templates
        FOREIGN KEY (template_id)
        REFERENCES templates(id),

    CONSTRAINT FK_downloads_template_versions
        FOREIGN KEY (template_version_id)
        REFERENCES template_versions(id)
);
GO


CREATE INDEX IX_downloads_template_id
    ON downloads(template_id);
GO


CREATE INDEX IX_downloads_user_id
    ON downloads(user_id);
GO


CREATE INDEX IX_downloads_downloaded_at
    ON downloads(downloaded_at);
GO