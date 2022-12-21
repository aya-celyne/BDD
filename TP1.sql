/*--- création des tablespace-------------

connect system/pswd

create tablespace intervention_tbs datafile 'c:\intervention_tbs.dat' size 100M autoextend on online;
create temporary tablespace intervention_temptbs tempfile 'c:\intervention_temptbstbs.dat' size 100M autoextend on;

/*-- si besoin de les supprimer --*/
drop tablespace intervention_tbs including contents and datafiles;
drop tablespace INTERVENTION_TEMPTBS including contents;

--- création de l'utilisateur------------

create user dbaintervention identified by psw default tablespace intervention_tbs temporary tablespace intervention_temptbs;

desc dba_users;

select username, created from dba_users where username=upper('dbaintervention');

/*-- si besoin de le supprimer --*/
drop user dbaintervention cascade;

---- accorder les touts les droits----------

grant all privileges to dbaintervention;

--- connexion avec l'utilisateur dbaintervention

connect dbaintervention/psw
show user;

---modifier le format date 

alter session set nls_date_format = 'DD/MM/RRRR HH24:MI:SS';

----création des tables de la BD--------------

---table client

create table CLIENT (
                      NUMCLIENT integer, 
                      CIV varchar2(3),
                      NOM varchar2(50), 
                      PRENOM varchar2(50), 
                      DATENAISSANCE date,  
                      ADRESSE varchar2(100), 
                      TELPROF varchar2(10), 
                      TELPRIV varchar2(10), 
                      FAX varchar2(10), 
                      constraint pk_client primary key(NUMCLIENT), 
                      constraint ck_civ check (CIV in ('M.','Mle', 'Mme')) );

desc CLIENT;

desc user_tables;

desc tabs;

select table_name, TABLESPACE_NAME from tabs; // afficher les tables de l'utilisateur à partie de la vue user_tables: tabs

---table employe

create table EMPLOYE (
                       NUMEMPLOYE integer, 
                       NOMEMP varchar2(50), 
                       PRENOMEMP varchar2(50), 
                       CATEGORIE varchar2(30), 
                       SALAIRE number, 
                       constraint ck_employe primary key(NUMEMPLOYE), 
                       constraint ck_categorie check(CATEGORIE in('Mécanicien','Assistant')));

select table_name, TABLESPACE_NAME from tabs;

---table MARQUE
 
create table MARQUE (
                      NUMMARQUE integer, 
                      MARQUE varchar2(50), 
                      PAYS varchar2(50),
                      constraint pk_marque primary key (NUMMARQUE));

---table modele

create table  MODELE (
                       NUMMODELE integer, 
                       NUMMARQUE integer, 
                       MODELE varchar2(100),
                       constraint pk_modele primary key(NUMMODELE),
                       constraint fk_marque foreign key(NUMMARQUE) references marque(NUMMARQUE) on delete cascade);

---table vehicule

create table  VEHICULE (
                         NUMVEHICULE integer, 
                         NUMCLIENT integer, 
                         NUMMODELE integer, 
                         NUMIMMAT varchar2(20), 
                         ANNEE varchar2(4),
                         constraint pk_vehicule primary key(NUMVEHICULE), 
                         constraint fk_client foreign key(NUMCLIENT) references client(NUMCLIENT) on delete cascade,
                         constraint fk_modele foreign key(NUMMODELE) references modele (NUMMODELE) on delete cascade);

---table  INTERVENTIONS 

create table INTERVENTIONS(
                            NUMINTERVENTION integer, 
                            NUMVEHICULE integer, 
                            TYPEINTERVENTION varchar2(50), 
                            DATEDEBINTERV date, 
                            DATEFININTERV date,  
                            COUTINTERV number,
                            constraint pk_intervention primary key(NUMINTERVENTION),
                            constraint fk_vehicule foreign key( NUMVEHICULE) references vehicule (NUMVEHICULE) on delete cascade);

--- table INTERVENANTS 

create table INTERVENANTS(
                           NUMINTERVENTION integer, 
                           NUMEMPLOYE integer, 
                           DATEDEBUT date, 
                           DATEFIN date,
                           constraint pk_intervenants primary key(NUMINTERVENTION, NUMEMPLOYE),
                           constraint fk_interventions foreign key(NUMINTERVENTION) references interventions (NUMINTERVENTION) on delete cascade,
                           constraint fk_employe foreign key (NUMEMPLOYE) references employe (NUMEMPLOYE) on delete cascade);

---table erreurs

CREATE TABLE TableErreurs   (adresse ROWID, utilisateur VARCHAR2(30), nomTable VARCHAR2(30),nomContrainte VARCHAR2(30));
select table_name, TABLESPACE_NAME from tabs;




---------- modification du schéma

5.	Ajouter l’attribut  DATEINSTALLATION  de type Date dans la relation EMPLOYE.

desc employe;

alter table employe add DATEINSTALLATION date;

desc employe;
---------------------------------------

6.	Ajouter la contrainte not null pour les attributs CATEGORIE, SALAIRE de la relation EMPLOYE.

desc employe;

desc user_constraints;

select constraint_name, constraint_type from user_constraints where table_name='EMPLOYE'; //afficher les contraintes de la table emplye de l'utilisateur
dbaintervention à partir de la vue user_constraints

alter table employe modify CATEGORIE not null;

desc employe;

alter table employe add constraint ck_salaire_null check(SALAIRE  is not null);

desc employe;

select constraint_name, constraint_type from user_constraints where table_name=upper('employe');


----------------------------------------------------------------------

7.	Modifier la longueur de l’attribut PRENOMEMP (agrandir, réduire).

desc employe;

alter table employe modify PRENOMEMP varchar2(51);

desc employe;

alter table employe modify PRENOMEMP varchar2(50);

desc employe;


-----------------------------------------------------------------------

8.	Supprimer la colonne DATEINSTALLATION  dans la table EMPLOYE. Vérifier la suppression. 

desc employe

alter table employe drop column DATEINSTALLATION;

desc employe

-----------------------------------------------------------------------------

9.	Renommer la colonne ADRESSE dans la table CLIENT par  ADRESSECLIENT. Vérifier.

desc client

alter table  client rename column ADRESSE  to ADRESSECLIENT;

desc client

------------------------------------------------------------------------------

10.	Ajouter la contrainte suivante : Date de début d’intervention doit être inférieur à la date de fin d’intervention.

select constraint_name, constraint_type from user_constraints where table_name=upper('interventions');

alter table interventions add constraint ck_dateinter check(DATEDEBINTERV<DATEFININTERV);

select constraint_name, constraint_type from user_constraints where table_name=upper('interventions');

-------------------------------------------------------------------------------------

11. Insertion

--------------------------------------------------------------------------------------

--12.	Supposons que le salaire de l’employé  BADI Hatem  est augmenté par 5000DA Que faut-il faire ?

select salaire from employe where nomemp='BADI' and prenomemp='Hatem';

update employe set salaire=salaire+5000 where nomemp='BADI' and prenomemp='Hatem';

select salaire from employe where nomemp='BADI' and prenomemp='Hatem';

set pagesize 150; // pour avoir un affichage sur une seule page

---------------------------------------------------------------------------

13.	Pour les interventions de mois de Février, ajouter cinq jours à la date de début. Désactiver la contrainte pour autoriser la modification. Réactiver la contrainte. 

on ne peut pas modifier une contrainte, il faut la supprimer puis recréer une autre (ici on va la désactiver et la réactiver)

select constraint_name from user_constraints where table_name='INTERVENTIONS';

select constraint_name, constraint_type,status from user_constraints where constraint_name='CK_DATEINTER';

select DATEDEBINTERV from interventions where DATEDEBINTERV like '%/02/%';
update interventions set DATEDEBINTERV=DATEDEBINTERV+5 where DATEDEBINTERV like '%/02/%';

--message d'erreur violation de la CK_DATES_VERFICATION: check constraint (DBACOMPTOIRS.CK_DATES_VERFICATION) violated

select  NUMINTERVENTION, DATEDEBINTERV, DATEFININTERV from interventions where  DATEDEBINTERV>DATEFININTERV;

-- désactiver la CI ck_dateinter

alter table interventions disable constraint ck_dateinter;

update interventions set DATEDEBINTERV=DATEDEBINTERV+5 where DATEDEBINTERV like '%/02/%';

select  NUMINTERVENTION, DATEDEBINTERV, DATEFININTERV from interventions where  DATEDEBINTERV>DATEFININTERV;

--réactiver la CI ck_dateinter



select * from tableerreurs;
alter table interventions enable constraint ck_dateinter exceptions into tableerreurs;
set linesize 200;
select * from tableerreurs;

select rowid, NUMINTERVENTION, DATEDEBINTERV, DATEFININTERV from interventions; (le rowid est ajouté par le SGBD pour afficher les adresses physique de chaque ligne d'une table)

desc tableerreurs;

-- la CI ck_dateinter n'est pas réactivée car les dates d'intervention dont la date DATEDEBINTERV>DATEFININTERV sont toujours dans la table interventions

select constraint_name, constraint_type,status from user_constraints where constraint_name=upper('ck_dateinter');

--pour la réactiver il faut supprimer les lignes qui ont ne respectent pas la CI , on suppose qu'on ne connait pas les id de l'intervention, on utilise alors rowid pour
 la retrouver.

delete from interventions where rowid in (select adresse from tableerreurs);

select  NUMINTERVENTION, DATEDEBINTERV, DATEFININTERV from interventions where  DATEDEBINTERV>DATEFININTERV;

alter table interventions enable constraint ck_dateinter exceptions into tableerreurs;

select constraint_name, constraint_type,status from user_constraints where constraint_name=upper('ck_dateinter');

update interventions set DATEDEBINTERV=DATEDEBINTERV+5 where DATEDEBINTERV like '%/02/%';

----------------------------------------------------------------------------------------------------