--DDL: limpeza
begin execute immediate 'drop table detalle_solicitud cascade constraints'; exception when others then null; end;
/
begin execute immediate 'drop table solicitud_prestamo cascade constraints'; exception when others then null; end;
/
begin execute immediate 'drop table equipo cascade constraints'; exception when others then null; end;
/
begin execute immediate 'drop table categoria_equipo cascade constraints'; exception when others then null; end;
/
begin execute immediate 'drop table empleado cascade constraints'; exception when others then null; end;
/
-- DDL: TABLAS
create table empleado (
    id_empleado  number primary key,
    nombre  varchar2(50) not null,
    apellido    varchar2(50) not null,
    departamento varchar2(50) not null,
    correo  varchar2(100) not null unique
);
create table categoria_equipo (
    id_categoria number primary key,
    nombre varchar2(50) not null unique
);
create table equipo (
    id_equipo number primary key,
    nombre varchar2(100) not null,
    marca varchar2(50) not null,
    modelo varchar2(50),
    numero_serie varchar2(50) unique,
    estado varchar2(50) default 'disponible' not null,
    id_categoria number not null,
    constraint fk_equipo_categoria foreign key (id_categoria) 
        references categoria_equipo(id_categoria),
    constraint chk_equipo_estado check (lower(estado) in ('disponible', 'prestado', 'mantenimiento'))
);
create table solicitud_prestamo (
    id_solicitud number primary key,
    fecha_solicitud  date default sysdate not null,
    fecha_uso date not null,
    fecha_devolucion date not null,
    motivo  varchar2(200) not null,
    estado  varchar2(20) default 'pendiente' not null,
    id_empleado number not null,
    constraint fk_solicitud_empleado foreign key (id_empleado) 
        references empleado(id_empleado),
    constraint chk_solicitud_estado check (lower(estado) in ('pendiente', 'aprobado', 'entregado', 'devuelto', 'cancelado')),
    constraint chk_solicitud_fecha check (fecha_devolucion >= fecha_uso)
);
create table detalle_solicitud (
    id_solicitud number not null,
    id_equipo number not null,
    observacion  varchar2(200),
    constraint pk_detalle_solicitud primary key (id_solicitud, id_equipo),
    constraint fk_detalle_solicitud foreign key (id_solicitud) 
        references solicitud_prestamo(id_solicitud) on delete cascade,
    constraint fk_detalle_equipo foreign key (id_equipo) 
        references equipo(id_equipo)
);
-- DATOS
insert into empleado (id_empleado, nombre, apellido, departamento, correo)
values (1, 'Carlos', 'Gomez', 'Informatica', 'cgomez@prueba.edu');
insert into empleado (id_empleado, nombre, apellido, departamento, correo)
values (2, 'Ana', 'Martínez', 'Recursos Humanos', 'amartinez@prueba.edu');
insert into empleado (id_empleado, nombre, apellido, departamento, correo)
values (3, 'Luis', 'Hernández', 'Capacitación', 'lhernandez@prueba.edu');
insert into empleado (id_empleado, nombre, apellido, departamento, correo)
values (4, 'María', 'López', 'Administración', 'mlopez@prueba.edu');
insert into empleado (id_empleado, nombre, apellido, departamento, correo)
values (5, 'Jorge', 'Ramírez', 'Mantenimiento', 'jramirez@prueba.edu');

insert into categoria_equipo (id_categoria, nombre) 
values (1, 'Audio');
insert into categoria_equipo (id_categoria, nombre) 
values (2, 'Proyección y Video');
insert into categoria_equipo (id_categoria, nombre) 
values (3, 'Cómputo');
insert into categoria_equipo (id_categoria, nombre) 
values (4, 'Accesorios');

insert into equipo (id_equipo, nombre, marca, modelo, numero_serie, estado, id_categoria)
values (101, 'Proyector Epson EB-X05', 'Epson', 'EB-X05', 'SN-EPS-001', 'disponible', 2);
insert into equipo (id_equipo, nombre, marca, modelo, numero_serie, estado, id_categoria)
values (102, 'Proyector Sony VPL', 'Sony', 'VPL-DX221', 'SN-SNY-002', 'disponible', 2);
insert into equipo (id_equipo, nombre, marca, modelo, numero_serie, estado, id_categoria)
values (103, 'Micrófono Inalámbrico Shure', 'Shure', 'BLX24/PG58', 'SN-SHU-003', 'disponible', 1);
insert into equipo (id_equipo, nombre, marca, modelo, numero_serie, estado, id_categoria)
values (104, 'Micrófono Corbatero', 'Sennheiser', 'XS Lav', 'SN-SEN-004', 'disponible', 1);
insert into equipo (id_equipo, nombre, marca, modelo, numero_serie, estado, id_categoria)
values (105, 'Bocina Portátil JBL', 'JBL', 'PartyBox 110', 'SN-JBL-005', 'prestado', 1);
insert into equipo (id_equipo, nombre, marca, modelo, numero_serie, estado, id_categoria)
values (106, 'Cámara Canon EOS Rebel', 'Canon', 'T7', 'SN-CAN-006', 'disponible', 2);
insert into equipo (id_equipo, nombre, marca, modelo, numero_serie, estado, id_categoria)
values (107, 'Cámara Sony Alpha', 'Sony', 'A6400', 'SN-SNY-007', 'disponible', 2);
insert into equipo (id_equipo, nombre, marca, modelo, numero_serie, estado, id_categoria)
values (108, 'Laptop Dell Latitude', 'Dell', '5420', 'SN-DLL-008', 'disponible', 3);
insert into equipo (id_equipo, nombre, marca, modelo, numero_serie, estado, id_categoria)
values (109, 'Laptop HP ProBook', 'HP', '450 G8', 'SN-HPP-009', 'prestado', 3);
insert into equipo (id_equipo, nombre, marca, modelo, numero_serie, estado, id_categoria)
values (110, 'Pantalla Proyección Trípode', 'KlipX', 'KPS-101', 'SN-KLP-010', 'disponible', 2);
insert into equipo (id_equipo, nombre, marca, modelo, numero_serie, estado, id_categoria)
values (111, 'Trípode Profesional', 'Manfrotto', 'MK290', 'SN-MAN-011', 'disponible', 4);
insert into equipo (id_equipo, nombre, marca, modelo, numero_serie, estado, id_categoria)
values (112, 'Cable HDMI 10m', 'Generic', 'HDMI-10M', 'SN-CAB-012', 'disponible', 4);
insert into equipo (id_equipo, nombre, marca, modelo, numero_serie, estado, id_categoria)
values (113, 'Presentador Inalámbrico', 'Logitech', 'R400', 'SN-LOG-013', 'disponible', 4);
insert into equipo (id_equipo, nombre, marca, modelo, numero_serie, estado, id_categoria)
values (114, 'Consola de Audio 8 Ch', 'Yamaha', 'MG10XU', 'SN-YMH-014', 'disponible', 1);
insert into equipo (id_equipo, nombre, marca, modelo, numero_serie, estado, id_categoria)
values (115, 'Laptop Lenovo ThinkPad', 'Lenovo', 'T14', 'SN-LNV-015', 'mantenimiento', 3);

insert into solicitud_prestamo (id_solicitud, fecha_solicitud, fecha_uso, fecha_devolucion, motivo, estado, id_empleado)
values (1001, sysdate, to_date('2026-03-10', 'yyyy-mm-dd'), to_date('2026-03-12', 'yyyy-mm-dd'), 'capacitación al personal', 'entregado', 1);
insert into solicitud_prestamo (id_solicitud, fecha_solicitud, fecha_uso, fecha_devolucion, motivo, estado, id_empleado)
values (1002, sysdate, to_date('2026-03-15', 'yyyy-mm-dd'), to_date('2026-03-16', 'yyyy-mm-dd'), 'reunión de gerencia', 'pendiente', 2);
insert into solicitud_prestamo (id_solicitud, fecha_solicitud, fecha_uso, fecha_devolucion, motivo, estado, id_empleado)
values (1003, sysdate, to_date('2026-03-20', 'yyyy-mm-dd'), to_date('2026-03-22', 'yyyy-mm-dd'), 'evento institucional', 'aprobado', 3);

insert into detalle_solicitud (id_solicitud, id_equipo, observacion)
values (1001, 105, 'incluye cable de alimentación');
insert into detalle_solicitud (id_solicitud, id_equipo, observacion)
values (1001, 109, 'con cargador original');
insert into detalle_solicitud (id_solicitud, id_equipo, observacion)
values (1002, 101, 'requiere cable hdmi');
insert into detalle_solicitud (id_solicitud, id_equipo, observacion)
values (1003, 103, 'con baterías cargadas');
insert into detalle_solicitud (id_solicitud, id_equipo, observacion)
values (1003, 106, 'con tarjeta de memoria sd');
commit;

select * from empleado;
select * from categoria_equipo;
select * from equipo;
select * from solicitud_prestamo;
select * from detalle_solicitud

--Quien pidio que
select 
    s.id_solicitud,
    e.nombre || ' ' || e.apellido as empleado,
    e.departamento,
    eq.nombre as equipo,
    s.fecha_uso,
    s.fecha_devolucion,
    s.estado
from solicitud_prestamo s
join empleado e on s.id_empleado = e.id_empleado
join detalle_solicitud d on s.id_solicitud = d.id_solicitud
join equipo eq on d.id_equipo = eq.id_equipo;

--equipos disponibles
select c.nombre as categoria, eq.nombre as equipo, eq.marca, eq.estado
from equipo eq
join categoria_equipo c on eq.id_categoria = c.id_categoria
where lower(eq.estado) = 'disponible';

--crear vistas
create or replace view v_solicitudes_activas as
select 
    s.id_solicitud,
    e.nombre || ' ' || e.apellido as solicitante,
    s.fecha_uso,
    s.estado
from solicitud_prestamo s
join empleado e on s.id_empleado = e.id_empleado
where s.estado in ('pendiente', 'aprobado', 'entregado');

--Triggers
create or replace trigger trg_marcar_equipo_prestado
after insert on detalle_solicitud
for each row
begin
    update equipo
    set estado = 'prestado'
    where id_equipo = :new.id_equipo;
end;
/

--PL/SQL
create or replace procedure sp_registrar_solicitud (
    p_id_solicitud in number,
    p_id_empleado  in number,
    p_fecha_uso    in date,
    p_fecha_dev    in date,
    p_motivo       in varchar2
) as
begin
    insert into solicitud_prestamo (id_solicitud, fecha_solicitud, fecha_uso, fecha_devolucion, motivo, estado, id_empleado)
    values (p_id_solicitud, sysdate, p_fecha_uso, p_fecha_dev, p_motivo, 'pendiente', p_id_empleado);
    commit;
end;
/

select * from v_solicitudes_activas;
select * from equipo where lower(estado) = 'disponible';

commit;

update equipo
set estado = 'mantenimiento'
where id_equipo = 103;
commit;

update empleado
set nombre = 'Juan',
    apellido = 'Gonzalez'
where id_empleado = 1;
commit;