---------------------------------------------
-- Comando DDL para criação das tabelas  ----
---------------------------------------------

-- 1. TABELAS BASE

CREATE TABLE ASSISTIDA (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    idade INT NOT NULL,
    identidadeGenero VARCHAR(50),
    n_social VARCHAR(100),
    escolaridade VARCHAR(50),
    religiao VARCHAR(50),
    nacionalidade VARCHAR(50) NOT NULL,
    zona VARCHAR(20) NOT NULL,
    ocupacao VARCHAR(100) NOT NULL,
    cad_social VARCHAR(50),
    dependentes INT NOT NULL,
    cor_raca VARCHAR(20) NOT NULL,
    endereco VARCHAR(50),
    deficiencia VARCHAR(50),
    limitacao VARCHAR(50)
);

CREATE TABLE FILHO (
    seq_filho INT NOT NULL,
    qtd_filhos_deficiencia INT,
    qtd_filho_agressor INT,
    qtd_filho_outro_relacionamento INT,
    viu_violencia BOOLEAN NOT NULL,
    violencia_gravidez BOOLEAN NOT NULL,
    id_assistida INT NOT NULL,
    FOREIGN KEY(id_assistida) REFERENCES ASSISTIDA(id) ON DELETE CASCADE,
    CONSTRAINT PK_filho PRIMARY KEY(id_assistida, seq_filho)
);

CREATE TABLE CONFLITO_FILHO (
    tipo_conflito VARCHAR(50) NOT NULL,
    id_assistida INT NOT NULL,
    seq_filho INT NOT NULL,
    FOREIGN KEY(id_assistida, seq_filho)
        REFERENCES FILHO(id_assistida, seq_filho) ON DELETE CASCADE,
    CONSTRAINT PK_conflito PRIMARY KEY(id_assistida, seq_filho, tipo_conflito)
);

CREATE TABLE FAIXA_FILHO (
    id_assistida INT NOT NULL,
    id_filhos INT NOT NULL,
    faixa_etaria VARCHAR(20) NOT NULL,
    FOREIGN KEY(id_assistida, seq_filho)
        REFERENCES FILHO(id_assistida, id_filhos) ON DELETE CASCADE,
    CONSTRAINT PK_faixa_filho PRIMARY KEY(id_assistida, id_filhos)
)

CREATE TABLE CASO (
    id_caso SERIAL PRIMARY KEY,
    data DATE NOT NULL,
    separacao VARCHAR(20) NOT NULL,
    novo_relac BOOLEAN NOT NULL,
    abrigo BOOLEAN NOT NULL,
    depen_finc BOOLEAN NOT NULL,
    mora_risco VARCHAR(20) NOT NULL,
    medida BOOLEAN NOT NULL,
    frequencia BOOLEAN NOT NULL,
    id_assistida INT NOT NULL,
    outras_informacoes text,
    FOREIGN KEY(id_assistida) REFERENCES ASSISTIDA(id) ON DELETE CASCADE
);

-- 2. FUNCIONARIOS E REDE

CREATE TABLE REDE_DE_APOIO (
    Email VARCHAR(100) PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL
);

CREATE TABLE CREDENCIAIS_PROCURADORIA (
    id INT PRIMARY KEY DEFAULT 1,
    email_institucional VARCHAR(100) NOT NULL,
    senha_email VARCHAR(255) NOT NULL,
    servico_smtp VARCHAR(50) DEFAULT 'gmail',
    CONSTRAINT check_single_row CHECK (id = 1)
);

-- Inserir valor padrão para não quebrar o sistema na primeira execução
INSERT INTO CREDENCIAIS_PROCURADORIA (id, email_institucional, senha_email)
VALUES (1, 'nao_configurado@email.com', 'vazio')
ON CONFLICT (id) DO NOTHING;

CREATE TABLE FUNCIONARIO (
    Email VARCHAR(100) PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Cargo VARCHAR(50) NOT NULL,
    Senha VARCHAR(100) NOT NULL
);

CREATE TABLE ADMINISTRADOR (
    Email VARCHAR(100) PRIMARY KEY,
    FOREIGN KEY (Email) REFERENCES FUNCIONARIO(Email) ON DELETE CASCADE
);

CREATE TABLE FUNCIONARIO_ACOMPANHA_CASO (
    email_funcionario VARCHAR(100) NOT NULL,
    id_caso INT NOT NULL,
    FOREIGN KEY(email_funcionario) REFERENCES FUNCIONARIO(Email) ON DELETE CASCADE,
    FOREIGN KEY(id_caso) REFERENCES CASO(id_caso) ON DELETE CASCADE,
    CONSTRAINT PK_func PRIMARY KEY(email_funcionario, id_caso)
);

CREATE TABLE ASSISTIDA_REDE_APOIO (
    id_assistida INT NOT NULL,
    email_rede VARCHAR(100),
    FOREIGN KEY(email_rede) REFERENCES REDE_DE_APOIO(Email),
    FOREIGN KEY(id_assistida) REFERENCES ASSISTIDA(id),
    CONSTRAINT PK_assistida_rede PRIMARY KEY(id_assistida, email_rede)
);

-- 3. AGRESSOR E MULTIVALORADOS

CREATE TABLE AGRESSOR (
    id_caso INT NOT NULL,
    id_assistida INT NOT NULL,
    id_agressor SERIAL NOT NULL,
    Nome VARCHAR(100) NOT NULL,
    Idade INT,
    Vinculo VARCHAR(100),
    doenca VARCHAR(100), 
    medida_protetiva BOOLEAN,
    suicidio BOOLEAN,
    financeiro BOOLEAN,
    arma_de_fogo BOOLEAN,

    PRIMARY KEY (id_caso, id_assistida, id_agressor),

    FOREIGN KEY (id_caso) REFERENCES CASO(id_caso) ON DELETE CASCADE,
    FOREIGN KEY (id_assistida) REFERENCES ASSISTIDA(id) ON DELETE CASCADE
);

CREATE TABLE SUBSTANCIAS_AGRESSOR (
    id_caso INT NOT NULL,
    id_assistida INT NOT NULL,
    id_agressor INT NOT NULL,
    tipo_substancia VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_caso, id_assistida, id_agressor, tipo_substancia),
    FOREIGN KEY (id_caso, id_assistida, id_agressor)
        REFERENCES AGRESSOR(id_caso, id_assistida, id_agressor) ON DELETE CASCADE
);

CREATE TABLE AMEACA_AGRESSOR (
    id_caso INT NOT NULL,
    id_assistida INT NOT NULL,
    id_agressor INT NOT NULL,
    alvo_ameaca VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_caso, id_assistida, id_agressor, alvo_ameaca),
    FOREIGN KEY (id_caso, id_assistida, id_agressor)
        REFERENCES AGRESSOR(id_caso, id_assistida, id_agressor) ON DELETE CASCADE
);

-- 4. VIOLENCIA 

CREATE TABLE VIOLENCIA (
    id_violencia SERIAL,
    id_caso INT NOT NULL,
    id_assistida INT NOT NULL,

    estupro BOOLEAN,
    data_ocorrencia DATE,

    PRIMARY KEY (id_violencia, id_caso, id_assistida),

    FOREIGN KEY (id_caso) REFERENCES CASO(id_caso) ON DELETE CASCADE,
    FOREIGN KEY (id_assistida) REFERENCES ASSISTIDA(id) ON DELETE CASCADE
);

-- ======= TIPOS MULTIVALORADOS =======

CREATE TABLE TIPO_VIOLENCIA (
    id_violencia INT NOT NULL,
    id_caso INT NOT NULL,
    id_assistida INT NOT NULL,
    tipo_violencia VARCHAR(80) NOT NULL,

    PRIMARY KEY (id_violencia, id_caso, id_assistida, tipo_violencia),

    FOREIGN KEY (id_violencia, id_caso, id_assistida)
        REFERENCES VIOLENCIA(id_violencia, id_caso, id_assistida) ON DELETE CASCADE
);

CREATE TABLE AMEACAS_VIOLENCIA (
    id_violencia INT NOT NULL,
    id_caso INT NOT NULL,
    id_assistida INT NOT NULL,
    tipo_ameaca VARCHAR(80) NOT NULL,

    PRIMARY KEY (id_violencia, id_caso, id_assistida, tipo_ameaca),

    FOREIGN KEY (id_violencia, id_caso, id_assistida)
        REFERENCES VIOLENCIA(id_violencia, id_caso, id_assistida) ON DELETE CASCADE
);

CREATE TABLE AGRESSAO_VIOLENCIA (
    id_violencia INT NOT NULL,
    id_caso INT NOT NULL,
    id_assistida INT NOT NULL,
    tipo_agressao VARCHAR(80) NOT NULL,

    PRIMARY KEY (id_violencia, id_caso, id_assistida, tipo_agressao),

    FOREIGN KEY (id_violencia, id_caso, id_assistida)
        REFERENCES VIOLENCIA(id_violencia, id_caso, id_assistida) ON DELETE CASCADE
);

CREATE TABLE COMPORTAMENTO_VIOLENCIA (
    id_violencia INT NOT NULL,
    id_caso INT NOT NULL,
    id_assistida INT NOT NULL,
    descricao_comportamento VARCHAR(200) NOT NULL,

    PRIMARY KEY (id_violencia, id_caso, id_assistida, descricao_comportamento),

    FOREIGN KEY (id_violencia, id_caso, id_assistida)
        REFERENCES VIOLENCIA(id_violencia, id_caso, id_assistida) ON DELETE CASCADE
);


-- 5. ANEXO


CREATE TABLE ANEXO (
    id_anexo SERIAL,
    id_caso INT NOT NULL,
    id_assistida INT NOT NULL,

    nome VARCHAR(120),
    tipo VARCHAR(30),
    dados BYTEA,

    PRIMARY KEY (id_anexo, id_caso, id_assistida),

    FOREIGN KEY (id_caso) REFERENCES CASO(id_caso) ON DELETE CASCADE,
    FOREIGN KEY (id_assistida) REFERENCES ASSISTIDA(id) ON DELETE CASCADE
);

-- 6. PREENCHIMENTO PROFISSIONAL

CREATE TABLE PREENCHIMENTO_PROFISSIONAL (
    id_preenchimento INT NOT NULL,
    id_caso INT NOT NULL,
    id_assistida INT NOT NULL,
    assistida_respondeu_sem_ajuda boolean NOT NULL,
    assistida_respondeu_com_auxilio boolean NOT NULL,
    assistida_sem_condicoes boolean NOT NULL,
    assistida_recusou boolean NOT NULL,
    terceiro_comunicante boolean NOT NULL,
    PRIMARY KEY (id_preenchimento),
    FOREIGN KEY (id_assistida) REFERENCES ASSISTIDA(id) ON DELETE CASCADE,
    FOREIGN KEY (id_caso) REFERENCES CASO(id_caso) ON DELETE CASCADE
);


CREATE TABLE HISTORICO (
    id SERIAL PRIMARY KEY,

    id_func VARCHAR(120),
    tipo VARCHAR(80) NOT NULL,
    mudanca TEXT NOT NULL,

    id_caso INT,
    id_assistida INT,

    FOREIGN KEY (id_func)
        REFERENCES FUNCIONARIO(email)
        ON DELETE SET NULL,

    FOREIGN KEY (id_caso)
    REFERENCES CASO(id_caso)
    ON DELETE SET NULL,

    FOREIGN KEY (id_assistida)
        REFERENCES ASSISTIDA(id)
        ON DELETE SET NULL
);


