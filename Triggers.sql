-----------------------------TP PL/SQL----------------------------
--- connexion avec l'utilisateur DBACOMPTOIRS  

connect dbaintervention/psw

--activer le serveur d'affichage

set serveroutput on

/*execution de l'exemple*/

DECLARE      
cursor cr is select  nomemp from employe where categorie ='Assistant';     	-- la définition du curseur PL/SQL     
 --c_rec cr%rowtype;     						-- c_rec prend le même type que cr (pas besoin de le declarer vu qu'on utilise la boucle for)
i integer; -- basically an integer
vide EXCEPTION;							 
BEGIN 
    i := 1;      
    for c_rec in cr loop  						-- mettre cr dans c_rec
     	dbms_output.put_line('L''employé N°' ||i||' est '|| c_rec.nomemp);
     	i := i+1; 
    	--exit when cr%notfound;    --pas besoin de l'ajouter (boucle for, tout se fait de manière implicite)  
    end loop;
if(i<2) then RAISE vide;
else
i := i-1; 
dbms_output.put_line('La catégorie Assistant  contient ' ||i||' employés ');
end if;
EXCEPTION     
WHEN vide THEN dbms_output.put_line('La catégorie Assistant ne contient aucun employé');
END;
/

--------------------------------------------------------------------------------------------------------------------------
utiliser select count(*) into a from employe where categorie ='Assistant'; pour avoir le nombre d'emplyés assistants
-------------------------------------------------------------------------------------------------------------------------

DECLARE      
cursor cr is select  nomemp from employe where categorie ='Assistant';     	-- la définition du curseur PL/SQL     
i integer; 
a integer;
vide EXCEPTION;							 
BEGIN 
    i := 1;      
    for c_rec in cr loop  						
     	dbms_output.put_line('L''employé N°' ||i||' est '|| c_rec.nomemp);
     	i := i+1; 
    	end loop;
if(i<2) then RAISE vide;
else
select count(*) into a from employe where categorie ='Assistant'; 
dbms_output.put_line('La catégorie assistant contient ' ||a||' employés ');
end if;
EXCEPTION     
WHEN vide THEN dbms_output.put_line('La catégorie Assistant ne contient aucun employé');
END;
/

--------------------------------------------------------------------------------------------------------------------------------------
afficher la catégorie à partir de la requête suivante

select categorie, count(*) from employe where categorie ='Assistant' group by categorie; (nombre d'employés de catégorie assistant)
--------------------------------------------------------------------------------------------------------------------------------------

DECLARE      
cursor cr is select  nomemp from employe where categorie ='Assistant';     	-- la définition du curseur PL/SQL     
i integer; 
a integer; -- pour recevoir le résultat du count
c employe.categorie%type; -- pour recevoir la catégorie assistant
vide EXCEPTION;							 
BEGIN 
    i := 1;      
    for c_rec in cr loop  						
     	dbms_output.put_line('L''employé N°' ||i||' est '|| c_rec.nomemp);
     	i := i+1; 
    	end loop;
if(i<2) then RAISE vide;
else
select categorie, count(*) into c, a from employe where categorie ='Assistant' group by categorie;
dbms_output.put_line('La catégorie ' || c ||  ' contient ' ||a||' employés ');
end if;
EXCEPTION     
WHEN vide THEN dbms_output.put_line('La catégorie Assistant ne contient aucun employé');
END;
/

***********************************************************************************************************

--1.	Ecrire un code PLSQL qui permet d’afficher pour chaque marque  le nombre de modèles.
declare
cursor cr is select marque, count(*) as nb_modeles
       from marque m, modele mm
	   where m.nummarque=mm.nummarque
	   group by marque
	   order by marque;
begin
for item in cr
loop
dbms_output.put_line('La marque '||item.marque||' contient '||item.nb_modeles||' modèles');
end loop;
exception
when NO_DATA_FOUND  then dbms_output.put_line('La base de données ne contient aucune marque');
when others then dbms_output.put_line('erreur '||sqlcode||sqlerrm);
end;
/

----------------------------------------------------------------------------------------------------
afficher le nombre de modèles pour toutes les marques même celles qui n'en n'ont pas
----------------------------------------------------------------------------------------------------

declare
cursor cr is select * from marque;
a integer;
begin
for item in cr
Loop
Select count(*) into a from modele where nummarque= item. nummarque;
dbms_output.put_line('La marque '||item.marque||' contient '||a||' modèles');
end loop;
exception
when NO_DATA_FOUND  then dbms_output.put_line('La base de données ne contient aucune marque');
when others then dbms_output.put_line('erreur '||sqlcode||sqlerrm);
end;
/

--------------------------------------------------------------------------------------------------
afficher pour chaque marque ses différents modèles ainsi que le nombre de modèles

-----------------------------------------------------------------------------------------------------------------------
Par exemple pour la marque 7, on affiche ses deux modèles, on a alors à declarer un autre curseur pour cet affichage
select * from modele where nummarque = 7;
-------------------------------------------------------------------------------------------------------------------------



declare
cursor cr is select * from marque;
a integer;
begin
for item in cr          -- ce curseur récupère toutes les marques
Loop
declare
cursor cr1 is select nummodele, modele from modele where nummarque= item. nummarque;
i integer;
vide exception;
begin
i:=0;
for v in cr1        -- ce curseur récupère les modèles d'une marque du curseur cr    
Loop
dbms_output.put_line('La marque '||item.marque||' possède le modèle '||v.NUMMODELE ||' '|| v.MODELE);
i:=1;
end loop;
if (i<1) then dbms_output.put_line('La marque '|| item.marque ||' ne contient aucun modèle'); --afficher un message pour les marques qui n'ont pas de modèle
end if;
end;
Select count(*) into a from modele where nummarque= item. nummarque;
dbms_output.put_line('La marque '||item.marque||' contient '||a||' modèles');
end loop;
exception
when NO_DATA_FOUND  then dbms_output.put_line('La base de données ne contient aucune marque');
when others then dbms_output.put_line('erreur '||sqlcode||sqlerrm);
end;
/


La marque HONDA ne contient aucun modèle
La marque HONDA contient 0 modèles ( si on ne veut pas afficher ce message):
----------------------------------------------------------------------------


declare
cursor cr is select * from marque;
a integer;
begin
for item in cr          -- ce curseur récupère toutes les marques
Loop
declare
cursor cr1 is select nummodele, modele from modele where nummarque= item. nummarque;
i integer;
vide exception;
begin
i:=0;
for v in cr1        -- ce curseur récupère les modèles d'une marque du curseur cr    
Loop
dbms_output.put_line('La marque '||item.marque||' possède le modèle '||v.NUMMODELE ||' '|| v.MODELE);
i:=1;
end loop;
if (i<1) then dbms_output.put_line('La marque '|| item.marque ||' ne contient aucun modèle'); --afficher un message pour les marques qui n'ont pas de modèle
else
Select count(*) into a from modele where nummarque= item. nummarque;  ---on l'a mis ici pour ne pas afficher le nombre de modèle si la marque n'a pas de modèles
dbms_output.put_line('La marque '||item.marque||' contient '||a||' modèles');
end if;
end;
end loop;
exception
when NO_DATA_FOUND  then dbms_output.put_line('La base de données ne contient aucune marque');
when others then dbms_output.put_line('erreur '||sqlcode||sqlerrm);
end;
/

*****************************************************************************************************************************************************

--2.	Ajouter la contrainte suivante : le salaire d’un employé doit être entre  10000 DA et 30000 DA. Le centre de maintenance décide d’augmenter le salaire de l’employé de catégorie assistant par 30% et le mécanicien par 50%.  Ecrire une procédure qui augmente le salaire  de chaque employé.  Désactiver la contrainte d’intégrité pour effectuer les mises à jour. Afficher pour chaque employé avec son nouveau salaire. 

alter table employe add constraint ck_salaire_value check (salaire>=10000 and salaire<=30000);


--------------------------------------------------------------------------------------------------------------------------

create or replace procedure mise_a_jour_salaire is
cursor cr is select numemploye,nomemp, prenomemp, categorie, salaire from employe;
newsalaire employe.salaire%type;
begin
for item in cr 
loop
if item.categorie='Mécanicien' 
then 
--begin
newsalaire:=item.salaire+item.salaire*0.5;
update employe set salaire=newsalaire where numemploye=item.numemploye;
dbms_output.put_line('L''employe '||item.nomemp||' '||item.prenomemp||' de catégorie '||item.categorie||' son salaire est passé de '||item.salaire ||' DA à '|| newsalaire||' DA ');
--end;
else 
begin
newsalaire:=item.salaire+item.salaire*0.3;
update employe set salaire=newsalaire where numemploye=item.numemploye;
dbms_output.put_line('L''employe '||item.nomemp||' '||item.prenomemp||' de catégorie '||item.categorie||' son salaire est passé de '||item.salaire ||' DA à '|| newsalaire||' DA ');
end;
end if;
end loop;
exception
when no_data_found then dbms_output.put_line('La base de données ne contient aucun employe');
when others then dbms_output.put_line('Erreur '||sqlcode||sqlerrm);
end mise_a_jour_salaire;
/
alter table employe disable constraint ck_salaire_value;
execute mise_a_jour_salaire;

----------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE mise_a_jour_salaire is
    cursor cr is select numemploye,nomemp, prenomemp, categorie, salaire from employe order by numemploye;
    newsalaire employe.salaire%type;
BEGIN
    FOR item IN cr 
    loop
        IF (item.categorie = 'Assistant') THEN 
            UPDATE employe SET salaire = salaire + salaire * 0.3 WHERE NUMEMPLOYE = item.NUMEMPLOYE;
        ELSE
            UPDATE employe SET salaire = salaire + salaire * 0.5 WHERE NUMEMPLOYE = item.NUMEMPLOYE;
        END IF;
        SELECT salaire INTO newsalaire FROM employe WHERE NUMEMPLOYE = item.NUMEMPLOYE;  
        dbms_output.put_line('L''employe '|| item.NOMEMP || ' ' || item.PRENOMEMP || '  de catégorie ' || item.categorie || ' son salaire est passé de ' || item.salaire || ' DA à ' || newsalaire);
    END loop;    
END;
/
execute mise_a_jour_salaire;

------------------------------------------------------------------------------------------------------------------------------------
ici on declare deux curseurs, un pour les employés mécaniciens, un autre pour les employés assistants

-----------------------------------------------------------------------------------------------------------------------------

create or replace procedure mise_a_jour_salaire is
cursor crm is select numemploye,nomemp, prenomemp, categorie, salaire from employe where categorie='Mécanicien' order by numemploye;
cursor cra is select numemploye,nomemp, prenomemp, categorie, salaire from employe where categorie='Assistant' order by numemploye;
newsalaire employe.salaire%type;
begin
for item in crm 
loop
newsalaire:=item.salaire+item.salaire*0.5;
update employe set salaire=newsalaire where numemploye=item.numemploye;
dbms_output.put_line('L''employe '||item.nomemp||' '||item.prenomemp||' de catégorie '||item.categorie||' son salaire est passé de '||item.salaire ||' DA à '|| newsalaire||' DA ');
end loop;
for v in cra
loop
newsalaire:=v.salaire+v.salaire*0.3;
update employe set salaire=newsalaire where numemploye=v.numemploye;
dbms_output.put_line('L''employe '||v.nomemp||' '||v.prenomemp||' de catégorie '||v.categorie||' son salaire est passé de '||v.salaire ||' DA à '|| newsalaire||' DA ');
end loop;
end mise_a_jour_salaire;
/
execute mise_a_jour_salaire;

----------------------------------------------------------------------------------------------------------------------------------------

create or replace procedure mise_a_jour_salaire is
cursor cr is select numemploye,nomemp, prenomemp, categorie, salaire from employe where categorie='Mécanicien' order by numemploye;
cursor cr1 is select numemploye,nomemp, prenomemp, categorie, salaire from employe where categorie='Assistant' order by numemploye;
newsalaire employe.salaire%type;
begin
for item in cr 
loop
update employe set salaire=salaire+salaire*0.5 where numemploye=item.numemploye;
select salaire into newsalaire from employe where numemploye=item.numemploye;
dbms_output.put_line('L''employe '||item.nomemp||' '||item.prenomemp||' de catégorie '||item.categorie||' son salaire est passé de '||item.salaire ||' DA à '|| newsalaire||' DA ');
end loop;
for item in cr1
loop
update employe set salaire=salaire+salaire*0.3 where numemploye=item.numemploye;
select salaire into newsalaire from employe where numemploye=item.numemploye;
dbms_output.put_line('L''employe '||item.nomemp||' '||item.prenomemp||' de catégorie '||item.categorie||' son salaire est passé de '||item.salaire ||' DA à '|| newsalaire||' DA ');
end loop;
end mise_a_jour_salaire;
/
execute mise_a_jour_salaire;


**************************************************************************************************************************************************

--3.	Ecrire une procédure Vérification (période intervention) qui retourne  « vérification positive » si la date début d’intervention est inférieur à la date de fin d’intervention, et retourne  « Vérification négative » sinon. Tester la procédure pour toutes les interventions dont les véhicules réparés sont d’année 1998.

--------------------------------------------------------------------------------------------------------------------------------

Utilisation d'une fonction qui doit forcément retourner un résultat, et sera appelée dans un bloc pl/sql
-------------------------------------------------------------------------------------------------------------------------------

create or replace function verfication_periode(datedeb date, datefin date) return varchar is
begin
if datedeb<datefin then return('Verfication postive');
else return('Verfication négative');
end if;
end verfication_periode;
/
declare 
cursor cr is select numimmat, datedebinterv, datefininterv from vehicule v, interventions i where i.numvehicule=v.numvehicule and annee='1998' order by numimmat;
begin
for item in cr
loop 
dbms_output.put_line(item.numimmat||' '||item.datedebinterv||' '||item.datefininterv||' '||verfication_periode(item.datedebinterv, item.datefininterv));
end loop;
exception
when no_data_found then dbms_output.put_line('La base de données ne contient aucun véhicule');
when others then dbms_output.put_line('Erreur '||sqlcode||sqlerrm);
end;
/

---------------------------------------------------------------------------------------------------------------------------------------------------------------
Utilisation d'une procédure avec paramètre, et l'appeler dans un bloc pl/sql (la procédure ne retourne pas de résultat)
---------------------------------------------------------------------------------------------------------------------------------------------------------------

create or replace procedure verfication_p(datedeb date, datefin date) is
begin
if datedeb<datefin then dbms_output.put_line('Verfication postive');
else dbms_output.put_line('Verfication négative');
end if;
end verfication_p;
/
declare 
cursor cr is select numimmat, datedebinterv, datefininterv from vehicule v, interventions i where i.numvehicule=v.numvehicule and annee='1998'  order by numimmat;
begin
for item in cr
loop 
dbms_output.put_line(item.numimmat||' '||item.datedebinterv||' '||item.datefininterv);
verfication_p(item.datedebinterv, item.datefininterv); --appel de la procédure
end loop;
exception
when no_data_found then dbms_output.put_line('La base de données ne contient aucun véhicule');
when others then dbms_output.put_line('Erreur '||sqlcode||sqlerrm);
end;
/

---------------------------------------------------------------------------------------------------------------------------------------------------------
Utiliser une procédure sans paramètre et faire tout le traitement dans la procédure, même la declaration du curseur
---------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE verification IS
    cursor cr IS select numimmat, datedebinterv, datefininterv from vehicule v, interventions i where i.numvehicule=v.numvehicule and annee='1998'  order by numimmat;
BEGIN
    FOR item IN cr 
    loop
        IF (item.DATEDEBINTERV < item.DATEFININTERV) THEN 
            dbms_output.put_line(item.numimmat||' '||item.datedebinterv||' '||item.datefininterv||' '|| ' vérification positive' );
        ELSE
            dbms_output.put_line(item.numimmat||' '||item.datedebinterv||' '||item.datefininterv||' '|| ' vérification négative' );
        END IF;
    END loop;    
END;
/
execute verification;


************************************************************************************************************************************************


--4.	Ecrire une fonction qui retourne, pour chaque employé donné, le nombre d’interventions effectuées. Exécuter la fonction pour plusieurs employés. Exemple : L’employé IGOUDJIL Redouane a fait 3 interventions.

select count(*) from intervenants where numemploye=62;
select count(*) into nb_inter from intervenants where numemploye=57;

create or replace function nb_intervention(numintervenant employe.numemploye%type) return int is
nb_interv int;
begin
select  count(*)  into nb_interv from  intervenants  where numemploye=numintervenant;
return nb_interv;
end nb_intervention;
/

select nb_intervention(57) from dual; 

declare 
cursor cr is select numemploye, nomemp, prenomemp from employe order by numemploye;
begin
for item in cr
loop 
dbms_output.put_line('L''employe'||' '||item.numemploye||' '||item.nomemp||' '||item.prenomemp||'a fait '||nb_intervention(item.numemploye)||' '||'interventions');
end loop;
exception
when no_data_found then dbms_output.put_line('La base de données ne contient aucun employe');
when others then dbms_output.put_line('Erreur '||sqlcode||sqlerrm);
end;
/

**********************************************************************************************************************************************

---5.	Créer une procédure qui permet d’ajouter une intervention à partir de tous les attributs nécessaires.  N’oublier pas de vérifier l’unicité de la clé et l’existence de clé étrangère vers véhicule. Affichez les messages d’erreurs en cas de problèmes. 

create or replace procedure Ajout_Intervention(Numinterv in interventions.numintervention%type, numv in interventions.numvehicule%type, typeinterv in interventions.typeintervention%type,datedeb in interventions.datedebinterv%type,datefin in interventions.datefininterv%type,coutinterv in interventions.coutinterv%type) is   
	    Num_interv interventions.numintervention%type;
	    num_vehicule interventions.numvehicule%type;
		erreur  boolean:= false;
BEGIN
-- vérifier le numéro d'interevention 'Numinterv'.
	  
	   DECLARE
	     NumInterv_null EXCEPTION;
	     NumInerv_existe EXCEPTION;
	   BEGIN
         if(Numinterv is NULL) then RAISE NumInterv_null;
         else
		  select numintervention into Num_interv from interventions where numintervention= Numinterv;
		  RAISE NumInerv_existe;
         end if;
       EXCEPTION
         WHEN NumInterv_null then DBMS_OUTPUT.PUT_LINE('erreur : le numéro d''intervention est obligatoire'); erreur:=true;
         WHEN NumInerv_existe then DBMS_OUTPUT.PUT_LINE('erreur : le numéro d''interevention existe déja'); erreur:=true;
         WHEN NO_DATA_FOUND then NULL; 
	   END;

 --vérifier le numéro de véhicule.
        DECLARE
	     numvehicule_null EXCEPTION;
	   BEGIN
         if(numv is NULL) then RAISE numvehicule_null;
         else
           select numvehicule into num_vehicule from vehicule where numvehicule =numv;
         end if;
       EXCEPTION
         WHEN numvehicule_null then DBMS_OUTPUT.PUT_LINE('erreur : le vehicule est obligatoire'); erreur:=true;
         WHEN NO_DATA_FOUND then DBMS_OUTPUT.PUT_LINE('erreur : le véhicule n''existe pas'); erreur:=true; 
	   END;
----- vérifier le type d'interevention.
       DECLARE
        type_intervention_null EXCEPTION;
       BEGIN
         if(typeinterv is NULL) then RAISE type_intervention_null;
         end if;
       EXCEPTION
         WHEN type_intervention_null then  DBMS_OUTPUT.PUT_LINE('error : le type d''intervention est obligatoire'); erreur:=true;
       END;
----- vérifier la date début d'interevention.
       DECLARE
        datedeb_intervention_null EXCEPTION;
       BEGIN
         if(datedeb is NULL) then RAISE datedeb_intervention_null;
         end if;
       EXCEPTION
         WHEN datedeb_intervention_null then  DBMS_OUTPUT.PUT_LINE('error : la date de début d''intervention est obligatoire'); erreur:=true;
       END;	   
----- vérifier la date fin d'interevention.
       DECLARE
        datefin_intervention_null EXCEPTION;
       BEGIN
         if(datefin is NULL) then RAISE datefin_intervention_null;
         end if;
       EXCEPTION
         WHEN datefin_intervention_null then  DBMS_OUTPUT.PUT_LINE('error : la date de fin d''intervention est obligatoire'); erreur:=true;
       END;	 
----- vérifier la date fin d'interevention est plus grand que la date de début d'interevention.
       DECLARE
        datefindeb_intervention EXCEPTION;
       BEGIN
         if(datefin <datedeb) then RAISE datefindeb_intervention;
         end if;
       EXCEPTION
         WHEN datefindeb_intervention then  DBMS_OUTPUT.PUT_LINE('error : la date de fin d''intervention doit être plus grande que la date de début'); erreur:=true;
       END;	
----- vérifier le coût d'interevention.
       DECLARE
        cout_intervention_null EXCEPTION;
       BEGIN
         if(coutinterv is NULL) then RAISE cout_intervention_null;
         end if;
       EXCEPTION
         WHEN cout_intervention_null then  DBMS_OUTPUT.PUT_LINE('error : le coût d''interevention est obligatoire'); erreur:=true;
       END;	
 if(erreur = false) then
	       insert into interventions values(Numinterv,numv, typeinterv ,datedeb,datefin, coutinterv );
	       commit;
	       DBMS_OUTPUT.PUT_LINE('l''interevention est bien ajoutée');
	   end if;      
    EXCEPTION
       WHEN OTHERS then  DBMS_OUTPUT.PUT_LINE('error : '||sqlcode||' '||sqlerrm);  
end Ajout_Intervention;
/

execute Ajout_Intervention('' , 100 , 'Réparation Systeme',TO_DATE('2006-06-30 09:00:00','RRRR-MM-DD HH24:MI:SS'),TO_DATE('2006-06-29 12:00:00','RRRR-MM-DD HH24:MI:SS'), 27000);
execute Ajout_Intervention(18 , 10 , 'Réparation Systeme',TO_DATE('2006-06-29 09:00:00','RRRR-MM-DD HH24:MI:SS'),TO_DATE('2006-06-30 12:00:00','RRRR-MM-DD HH24:MI:SS'), 27000);


