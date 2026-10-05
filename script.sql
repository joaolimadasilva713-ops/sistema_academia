CREATE DATABASE db_sistema_treinos;
USE db_sistema_treinos;

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    tipo ENUM('aluno') DEFAULT 'aluno',
    data_nascimento DATE,
    peso_kg DECIMAL(5,2),
    altura_cm INT,
    nivel VARCHAR(20) DEFAULT 'iniciante',
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE anamnese (
    id_anamnese INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT UNIQUE,
    possui_lesao BOOLEAN DEFAULT FALSE,
    descricao_lesoes TEXT,
    problemas_cardiacos BOOLEAN DEFAULT FALSE,
    hipertensao BOOLEAN DEFAULT FALSE,
    tomando_medicamentos BOOLEAN DEFAULT FALSE,
    observacoes_medicas TEXT,
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_anamnese_aluno
    FOREIGN KEY (id_aluno)
    REFERENCES usuarios(id_usuario)
    ON DELETE CASCADE
);

CREATE TABLE exercicios (
    id_exercicio INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    grupo_muscular VARCHAR(50) NOT NULL,
    equipamento VARCHAR(50),
    instrucao_execucao TEXT,
    url_midia VARCHAR(255)
);

CREATE TABLE treinos (
    id_treino INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT,
    nome_treino VARCHAR(50) NOT NULL,
    dia_semana_sugerido VARCHAR(20),
    observacoes TEXT,
    ativo BOOLEAN DEFAULT TRUE,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_treinos_aluno
    FOREIGN KEY (id_aluno)
    REFERENCES usuarios(id_usuario)
    ON DELETE CASCADE
);

CREATE TABLE itens_treino (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_treino INT,
    id_exercicio INT,
    ordem INT NOT NULL,
    series INT DEFAULT 3,
    repeticoes_min INT NOT NULL,
    repeticoes_max INT NOT NULL,
    descanso_segundos INT DEFAULT 60,

    CONSTRAINT fk_itens_treino
    FOREIGN KEY (id_treino)
    REFERENCES treinos(id_treino)
    ON DELETE CASCADE,

    CONSTRAINT fk_itens_exercicio
    FOREIGN KEY (id_exercicio)
    REFERENCES exercicios(id_exercicio)
);

CREATE TABLE sessoes_treino (
    id_sessao INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT,
    id_treino INT,
    data_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_fim TIMESTAMP NULL,
    observacoes_aluno TEXT,

    CONSTRAINT fk_sessoes_aluno
    FOREIGN KEY (id_aluno)
    REFERENCES usuarios(id_usuario)
    ON DELETE CASCADE,

    CONSTRAINT fk_sessoes_treino
    FOREIGN KEY (id_treino)
    REFERENCES treinos(id_treino)
);

CREATE TABLE registros_execucao (
    id_registro INT AUTO_INCREMENT PRIMARY KEY,
    id_sessao INT,
    id_item_treino INT,
    serie_numero INT NOT NULL,
    carga_utilizada_kg DECIMAL(5,2) NOT NULL,
    repeticoes_realizadas INT NOT NULL,
    observacao TEXT,

    CONSTRAINT fk_registros_sessao
    FOREIGN KEY (id_sessao)
    REFERENCES sessoes_treino(id_sessao)
    ON DELETE CASCADE,

    CONSTRAINT fk_registros_item
    FOREIGN KEY (id_item_treino)
    REFERENCES itens_treino(id_item)
);