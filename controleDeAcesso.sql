----Criação de Usuário: AdministradorBD
CREATE USER admin_procuradoria WITH PASSWORD 'admin1234';

----´Controle de Acessos: AdministradorBD
GRANT CONNECT ON DATABASE "pem-ocara" TO admin_procuradoria;
GRANT USAGE ON SCHEMA public TO admin_procuradoria;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_procuradoria;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin_procuradoria;

----Criação de Usuário: FuncionarioBD
CREATE USER funcionario_procuradoria WITH PASSWORD 'funcionario1234';

----´Controle de Acessos: FuncionarioBD
GRANT CONNECT ON DATABASE "pem-ocara" TO funcionario_procuradoria;
GRANT USAGE ON SCHEMA public TO funcionario_procuradoria;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO funcionario_procuradoria;
REVOKE SELECT ON funcionario FROM funcionario_procuradoria;