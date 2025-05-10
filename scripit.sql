CREATE TABLE tb_cliente (
cod_cliente SERIAL PRIMARY KEY,
nome VARCHAR(200) NOT NULL
);

CREATE TABLE IF NOT EXISTS tb_pedido(
cod_pedido SERIAL PRIMARY KEY,
data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
data_modificacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
status VARCHAR DEFAULT 'aberto',
cod_cliente INT NOT NULL,
CONSTRAINT fk_cliente FOREIGN KEY (cod_cliente) REFERENCES
tb_cliente(cod_cliente)
);

CREATE TABLE tb_tipo_item(
cod_tipo SERIAL PRIMARY KEY,
descricao VARCHAR(200) NOT NULL
);

INSERT INTO tb_tipo_item (descricao) VALUES ('Bebida'), ('Comida');

CREATE TABLE IF NOT EXISTS tb_item(
cod_item SERIAL PRIMARY KEY,
descricao VARCHAR(200) NOT NULL,
valor NUMERIC (10, 2) NOT NULL,
cod_tipo INT NOT NULL,
CONSTRAINT fk_tipo_item FOREIGN KEY (cod_tipo) REFERENCES
tb_tipo_item(cod_tipo)
);
INSERT INTO tb_item (descricao, valor, cod_tipo) VALUES
('Refrigerante', 7, 1), ('Suco', 8, 1), ('Hamburguer', 12, 2), ('Batata frita', 9, 2);

CREATE TABLE IF NOT EXISTS tb_item_pedido(
--surrogate key, assim cod_item pode repetir
cod_item_pedido SERIAL PRIMARY KEY,
cod_item INT,
cod_pedido INT,
CONSTRAINT fk_item FOREIGN KEY (cod_item) REFERENCES tb_item (cod_item),
CONSTRAINT fk_pedido FOREIGN KEY (cod_pedido) REFERENCES tb_pedido
(cod_pedido)
);




--1.1
create table log(
    cod_log serial primary key,
    data TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    nome_operacao varchar(200)
)