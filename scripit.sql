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


--1.2

create or replace procedure total_pedidos(cod int)
LANGUAGE plpgsql
as $$
DECLARE
    total_pedidos_cliente int;
BEGIN
    select count(cod_pedido) into total_pedidos_cliente from tb_pedido
    where cod_cliente = cod;    

    raise notice 'O total de pedidos desse cliente é %', total_pedidos_cliente;

    INSERT INTO log (nome_operacao)
    VALUES ('total_pedidos');

end;
$$

do $$
begin
    call total_pedidos(1);
end;
$$

--1.3

create or replace procedure total_pedidos_out( in cod int, out total int)
LANGUAGE plpgsql
as $$
BEGIN

    select count(cod_pedido) into total from tb_pedido
    where cod_cliente = cod;    

    INSERT INTO log (nome_operacao)
    VALUES ('total_pedidos_out');

end;
$$

do $$
DECLARE
    total int;
begin
    call total_pedidos_out(1, total);
    raise notice 'O total de pedidos desse cliente é %', total;
end;
$$


--1.4

create or replace procedure total_pedidos_inout( INOUT total_pedidos int  )
LANGUAGE plpgsql
as $$
BEGIN

    select count(cod_pedido) into total_pedidos from tb_pedido
    where cod_cliente = total_pedidos;    

    INSERT INTO log (nome_operacao)
    VALUES ('total_pedidos_inout');

end;
$$

do $$
DECLARE
    cod_cliente int := 1 ;
begin
    call total_pedidos_inout(cod_cliente);
    raise notice 'O total de pedidos desse cliente é %', cod_cliente;
end;
$$