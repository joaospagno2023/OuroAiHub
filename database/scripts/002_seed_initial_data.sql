USE OuroAIHub;
GO


/* ============================================================
   DEPARTMENTS
   ============================================================ */

INSERT INTO departments
(
    name,
    description
)
VALUES
(
    N'TI',
    N'Tecnologia da Informação'
),
(
    N'Fiscal',
    N'Departamento Fiscal'
),
(
    N'Comercial',
    N'Departamento Comercial'
),
(
    N'Financeiro',
    N'Departamento Financeiro'
),
(
    N'RH',
    N'Recursos Humanos'
),
(
    N'Administrativo',
    N'Departamento Administrativo'
);
GO


/* ============================================================
   ROLES
   ============================================================ */

INSERT INTO roles
(
    name,
    description
)
VALUES
(
    N'ADMIN',
    N'Administrador com acesso completo ao sistema'
),
(
    N'MANAGER',
    N'Gestor de departamento'
),
(
    N'USER',
    N'Usuário padrão'
);
GO


/* ============================================================
   PERMISSIONS
   ============================================================ */

INSERT INTO permissions
(
    name,
    description
)
VALUES
(
    N'TEMPLATES_VIEW',
    N'Visualizar templates'
),
(
    N'TEMPLATES_CREATE',
    N'Criar templates'
),
(
    N'TEMPLATES_EDIT',
    N'Editar templates'
),
(
    N'TEMPLATES_DELETE',
    N'Excluir templates'
),
(
    N'TEMPLATES_PUBLISH',
    N'Publicar templates'
),
(
    N'TEMPLATES_DOWNLOAD',
    N'Baixar templates'
),
(
    N'TEMPLATES_MANAGE_ALL',
    N'Gerenciar templates de todos os departamentos'
),
(
    N'USERS_VIEW',
    N'Visualizar usuários'
),
(
    N'USERS_MANAGE',
    N'Gerenciar usuários'
),
(
    N'DEPARTMENTS_MANAGE',
    N'Gerenciar departamentos'
);
GO


/* ============================================================
   ADMIN PERMISSIONS
   ============================================================ */

INSERT INTO role_permissions
(
    role_id,
    permission_id
)
SELECT
    r.id,
    p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name = N'ADMIN';
GO


/* ============================================================
   MANAGER PERMISSIONS
   ============================================================ */

INSERT INTO role_permissions
(
    role_id,
    permission_id
)
SELECT
    r.id,
    p.id
FROM roles r
INNER JOIN permissions p
    ON p.name IN
    (
        N'TEMPLATES_VIEW',
        N'TEMPLATES_CREATE',
        N'TEMPLATES_EDIT',
        N'TEMPLATES_PUBLISH',
        N'TEMPLATES_DOWNLOAD'
    )
WHERE r.name = N'MANAGER';
GO


/* ============================================================
   USER PERMISSIONS
   ============================================================ */

INSERT INTO role_permissions
(
    role_id,
    permission_id
)
SELECT
    r.id,
    p.id
FROM roles r
INNER JOIN permissions p
    ON p.name IN
    (
        N'TEMPLATES_VIEW',
        N'TEMPLATES_DOWNLOAD'
    )
WHERE r.name = N'USER';
GO


/* ============================================================
   CATEGORIES
   ============================================================ */

INSERT INTO categories
(
    name,
    description
)
VALUES
(
    N'AI Agent',
    N'Templates para agentes de Inteligência Artificial'
),
(
    N'n8n',
    N'Workflows e automações para n8n'
),
(
    N'Prompts',
    N'Prompts para modelos de Inteligência Artificial'
),
(
    N'WhatsApp',
    N'Automação e atendimento via WhatsApp'
),
(
    N'RAG',
    N'Retrieval-Augmented Generation'
),
(
    N'Automação',
    N'Automações utilizando Inteligência Artificial'
),
(
    N'Fiscal',
    N'Templates relacionados à área fiscal'
),
(
    N'Desenvolvimento',
    N'Templates para desenvolvimento de software'
);
GO