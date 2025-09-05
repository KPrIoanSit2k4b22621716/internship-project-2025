

CREATE TABLE fakulteti (
    fakultetid   NUMBER NOT NULL,
    fullname     VARCHAR2(100) NOT NULL,
    shortname    VARCHAR2(20)
) TABLESPACE USERS;

ALTER TABLE fakulteti ADD CONSTRAINT fakulteti_pk PRIMARY KEY (fakultetid)
USING INDEX TABLESPACE USERS;

CREATE TABLE grupi (
    groupid   NUMBER NOT NULL,
    name      VARCHAR2(10) NOT NULL,
    specid    NUMBER NOT NULL,
    kurs      NUMBER NOT NULL
) TABLESPACE USERS;

ALTER TABLE grupi ADD CONSTRAINT grupi_pk PRIMARY KEY (groupid)
USING INDEX TABLESPACE USERS;
ALTER TABLE grupi ADD education_type_id NUMBER;




CREATE TABLE izpiti (
    izpitid     NUMBER NOT NULL,
    subjectid   NUMBER NOT NULL,
    groupid     NUMBER NOT NULL,
    "Date"      DATE NOT NULL,
    type        VARCHAR2(10)
) TABLESPACE USERS;

ALTER TABLE izpiti ADD CONSTRAINT izpiti_pk PRIMARY KEY (izpitid)
USING INDEX TABLESPACE USERS;

CREATE TABLE katedri (
    katedraid    NUMBER NOT NULL,
    name         VARCHAR2(50) NOT NULL,
    fakultetid   NUMBER NOT NULL
) TABLESPACE USERS;

ALTER TABLE katedri ADD CONSTRAINT katedri_pk PRIMARY KEY (katedraid)
USING INDEX TABLESPACE USERS;

CREATE TABLE lecturers (
    lecturerid    NUMBER NOT NULL,
    titla         VARCHAR2(20) NOT NULL,
    firstname     VARCHAR2(30) NOT NULL,
    lastname      VARCHAR2(30) NOT NULL,
    lecturernom   VARCHAR2(5) NOT NULL,
    katedraid     NUMBER NOT NULL
) TABLESPACE USERS;

ALTER TABLE lecturers
    ADD CONSTRAINT chk_lecturernom_format CHECK (REGEXP_LIKE(lecturernom, '^10[0-9]{3}$'));

ALTER TABLE lecturers ADD CONSTRAINT lecturers_pk PRIMARY KEY (lecturerid)
USING INDEX TABLESPACE USERS;

CREATE TABLE ocenki (
    gradeid      NUMBER NOT NULL,
    studentid    NUMBER NOT NULL,
    subjectid    NUMBER NOT NULL,
    lecturerid   NUMBER NOT NULL,
    grade        NUMBER NOT NULL,
    "Date"       DATE NOT NULL
) TABLESPACE USERS;

ALTER TABLE ocenki
    ADD CONSTRAINT chk_grade_range CHECK (grade BETWEEN 1 AND 6);

ALTER TABLE ocenki ADD CONSTRAINT ocenki_pk PRIMARY KEY (gradeid)
USING INDEX TABLESPACE USERS;

CREATE TABLE predmeti (
    subjectid   NUMBER NOT NULL,
    name        VARCHAR2(100) NOT NULL,
    semestur    NUMBER NOT NULL,
    specid      NUMBER NOT NULL
) TABLESPACE USERS;

ALTER TABLE predmeti ADD CONSTRAINT predmeti_pk PRIMARY KEY (subjectid)
USING INDEX TABLESPACE USERS;

CREATE TABLE programi (
    programid    NUMBER NOT NULL,
    groupid      NUMBER NOT NULL,
    subjectid    NUMBER NOT NULL,
    day          VARCHAR2(10) NOT NULL,
    hour         VARCHAR2(10) NOT NULL,
    lecturerid   NUMBER NOT NULL
) TABLESPACE USERS;

ALTER TABLE programi
    ADD type VARCHAR2(20) NOT NULL
        CHECK (type IN ('Lecture', 'Exercise'));

ALTER TABLE programi ADD CONSTRAINT programi_pk PRIMARY KEY (programid)
USING INDEX TABLESPACE USERS;

CREATE TABLE specialnosti (
    specid       NUMBER NOT NULL,
    name         VARCHAR2(100) NOT NULL,
    shortname    VARCHAR2(10) NOT NULL,
    fakultetid   NUMBER NOT NULL
) TABLESPACE USERS;

ALTER TABLE specialnosti ADD CONSTRAINT specialnosti_pk PRIMARY KEY (specid)
USING INDEX TABLESPACE USERS;

CREATE TABLE students (
    studentid           NUMBER NOT NULL,
    firstname           VARCHAR2(30) NOT NULL,
    lastname            VARCHAR2(30) NOT NULL,
    facnom              VARCHAR2(8) NOT NULL,
    form_na_obuchenie   VARCHAR2(20) NOT NULL,
    oks                 VARCHAR2(20) NOT NULL,
    priem               NUMBER NOT NULL,
    fakultetid          NUMBER NOT NULL,
    specid              NUMBER NOT NULL,
    groupid             NUMBER NOT NULL,
    semesturcount       NUMBER NOT NULL,
    kurs                NUMBER NOT NULL
) TABLESPACE USERS;

ALTER TABLE students ADD CONSTRAINT students_pk PRIMARY KEY (studentid)
USING INDEX TABLESPACE USERS;

CREATE TABLE users (
    userid      INTEGER NOT NULL,
    username    VARCHAR2(50) NOT NULL,
    password    VARCHAR2(100) NOT NULL,
    role        VARCHAR2(20) NOT NULL
    
) TABLESPACE USERS;



ALTER TABLE users ADD CONSTRAINT users_pk PRIMARY KEY (userid)
USING INDEX TABLESPACE USERS;

ALTER TABLE users ADD CONSTRAINT users__un UNIQUE (username) USING INDEX TABLESPACE USERS;

CREATE TABLE education_types (
    education_type_id NUMBER PRIMARY KEY,
    education_type_name VARCHAR2(50) NOT NULL 
)TABLESPACE USERS;



ALTER TABLE grupi
    ADD CONSTRAINT grupi_specialnosti_fk FOREIGN KEY (specid)
        REFERENCES specialnosti (specid);
ALTER TABLE grupi
ADD CONSTRAINT fk_grupi_education_type FOREIGN KEY (education_type_id)
REFERENCES education_types(education_type_id);


ALTER TABLE izpiti
    ADD CONSTRAINT izpiti_grupi_fk FOREIGN KEY (groupid)
        REFERENCES grupi (groupid);

ALTER TABLE izpiti
    ADD CONSTRAINT izpiti_predmeti_fk FOREIGN KEY (subjectid)
        REFERENCES predmeti (subjectid);

ALTER TABLE katedri
    ADD CONSTRAINT katedri_fakulteti_fk FOREIGN KEY (fakultetid)
        REFERENCES fakulteti (fakultetid);

ALTER TABLE lecturers
    ADD CONSTRAINT lecturers_katedri_fk FOREIGN KEY (katedraid)
        REFERENCES katedri (katedraid);

ALTER TABLE ocenki
    ADD CONSTRAINT ocenki_lecturers_fk FOREIGN KEY (lecturerid)
        REFERENCES lecturers (lecturerid);

ALTER TABLE ocenki
    ADD CONSTRAINT ocenki_predmeti_fk FOREIGN KEY (subjectid)
        REFERENCES predmeti (subjectid);

ALTER TABLE ocenki
    ADD CONSTRAINT ocenki_students_fk FOREIGN KEY (studentid)
        REFERENCES students (studentid);



ALTER TABLE programi
    ADD CONSTRAINT programi_grupi_fk FOREIGN KEY (groupid)
        REFERENCES grupi (groupid);

ALTER TABLE programi
    ADD CONSTRAINT programi_lecturers_fk FOREIGN KEY (lecturerid)
        REFERENCES lecturers (lecturerid);

ALTER TABLE programi
    ADD CONSTRAINT programi_predmeti_fk FOREIGN KEY (subjectid)
        REFERENCES predmeti (subjectid);

ALTER TABLE specialnosti
    ADD CONSTRAINT specialnosti_fakulteti_fk FOREIGN KEY (fakultetid)
        REFERENCES fakulteti (fakultetid);

ALTER TABLE students
    ADD CONSTRAINT students_fakulteti_fk FOREIGN KEY (fakultetid)
        REFERENCES fakulteti (fakultetid);

ALTER TABLE students
    ADD CONSTRAINT students_grupi_fk FOREIGN KEY (groupid)
        REFERENCES grupi (groupid);

ALTER TABLE students
    ADD CONSTRAINT students_specialnosti_fk FOREIGN KEY (specid)
        REFERENCES specialnosti (specid);

ALTER TABLE users
    ADD CONSTRAINT users_lecturers_fk FOREIGN KEY (relatedid)
        REFERENCES lecturers (lecturerid);
        
ALTER TABLE students
ADD education_type_id NUMBER;

ALTER TABLE students
ADD CONSTRAINT fk_education_type
FOREIGN KEY (education_type_id)
REFERENCES education_types(education_type_id);





INSERT INTO fakulteti (fakultetid, fullname, shortname) VALUES (1, 'Faculty of Mechanical Engineering and Technology', 'MFT');
INSERT INTO fakulteti (fakultetid, fullname, shortname) VALUES (2, 'English-Taught Education', 'ETE');
INSERT INTO fakulteti (fakultetid, fullname, shortname) VALUES (3, 'Shipbuilding Faculty', 'KF');
INSERT INTO fakulteti (fakultetid, fullname, shortname) VALUES (4, 'Faculty of Electrical Engineering', 'EF');
INSERT INTO fakulteti (fakultetid, fullname, shortname) VALUES (6, 'Faculty of Computer Science and Automation', 'FITA');
INSERT INTO fakulteti (fakultetid, fullname, shortname) VALUES (7, 'Dobrudzha Technological College', 'DTK');
INSERT INTO fakulteti (fakultetid, fullname, shortname) VALUES (9, 'College within TU - Varna', 'KTU');
INSERT INTO fakulteti (fakultetid, fullname, shortname) VALUES (10, 'Department of Language and Continuing Education and Sport', 'DEPOS');


-- ??? (fakultetid = 1)
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (11, 'Technology of Machine Building and Metal Cutting Machines', 'TMMM', 1);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (12, 'Materials Science and Technology of Materials', 'MTM', 1);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (14, 'General University Workshop', 'GUW', 1);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (21, 'Transport Technology and Equipment', 'TTT', 1);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (23, 'Mechanics and Machine Elements', 'MME', 1);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (31, 'Industrial Management', 'IM', 1);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (82, 'Plant Growing', 'P', 1);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (83, 'Automotive Engineering', 'AE', 1);

-- ?? (fakultetid = 3)
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (13, 'Industrial Design', 'ID', 3);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (26, 'Thermal Engineering', 'T', 3);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (34, 'Shipbuilding, Ship Machines and Mechanisms', 'KKMM', 3);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (35, 'Navigation, Transport Management and Waterway Protection', 'KUTOCHVP', 3);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (81, 'Ecology and Environmental Protection', 'EOOS', 3);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (102, 'Fleet and Port Operations', 'FPO', 3);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (103, 'Electrical Equipment of Ships', 'EES', 3);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (107, 'Engineering Ecology', 'IE', 3);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (108, 'Intelligent Transport Systems', 'ITS', 3);




-- ?? (fakultetid = 4)
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (41, 'Power Supply and Electrical Equipment', 'ESEO', 4);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (42, 'Power Engineering', 'EE', 4);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (43, 'Electrical Engineering and Electrical Technologies', 'ETET', 4);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (44, 'Theoretical and Measurement Electrical Engineering', 'TIE', 4);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (45, 'Mathematics and Physics', 'MF', 4);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (91, 'Social and Legal Sciences', 'SPN', 4);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (100, 'Biomedical Electronics', 'BME', 4);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (101, 'Renewable Energy Sources', 'RES', 4);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (56, 'Power Supply and Electrical Equipment', 'ESEO', 4);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (104, 'Electrical Engineering and Renewable Energy Sources', 'EERES', 4);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (105, 'Civil Protection in Disasters and Accidents', 'CPDA', 4);







-- ???? (fakultetid = 6)
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (54, 'Communication Technology and Technologies', 'KTT', 6);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (55, 'Electronic Technology and Microelectronics', 'ETM', 6);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (61, 'Production Automation', 'AP', 6);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (64, 'Computer Science and Technologies', 'KHT', 6);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (65, 'Software and Internet Technologies', 'SIT', 6);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (66, 'Automation, Information and Control Computer Systems', 'AICCS', 6);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (67, 'Automation, Robotics and Control Computer Systems', 'ARUKS', 6);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (106, 'Artificial Intelligence', 'AI', 6);


-- ??? (fakultetid = 7)
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (75, 'Dobrudzha Technological College', 'DTK', 7);

-- ??? (fakultetid = 9)
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (92, 'College within TU - Varna', 'KTU', 9);

-- ????? (fakultetid = 10)
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (37, 'Physical Education and Sport', 'FVS', 10);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (53, 'Section "Language Training and Continuing Qualification"', 'EOPK', 10);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (62, 'Section "Mathematics"', 'Math', 10);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (63, 'Physics', 'Physics', 10);
INSERT INTO specialnosti (specid, name, shortname, fakultetid) VALUES (98, 'Department of Language and Continuing Education and Sport', 'DEPOS', 10);

INSERT INTO education_types (education_type_id, education_type_name) VALUES (1, 'Full-time');
INSERT INTO education_types (education_type_id, education_type_name) VALUES (2, 'Part-time');


DECLARE
    v_groupid NUMBER := 1;
    v_podgrupa VARCHAR2(1);
    v_education_type VARCHAR2(10);
    v_education_type_id NUMBER;
BEGIN
    FOR et IN (
        SELECT 1 as id, 'Full-time' as txt FROM dual 
        UNION ALL 
        SELECT 2, 'Part-time' FROM dual
    )
    LOOP
        v_education_type_id := et.id;
        v_education_type := et.txt;

        FOR rec IN (
            SELECT specid, shortname FROM (
                SELECT 11 specid, 'TMMM' shortname FROM dual UNION ALL
                SELECT 12, 'MTM' FROM dual UNION ALL
                SELECT 14, 'GUW' FROM dual UNION ALL
                SELECT 21, 'TTT' FROM dual UNION ALL
                SELECT 23, 'MME' FROM dual UNION ALL
                SELECT 31, 'IM' FROM dual UNION ALL
                SELECT 82, 'P' FROM dual UNION ALL
                SELECT 13, 'ID' FROM dual UNION ALL
                SELECT 26, 'T' FROM dual UNION ALL
                SELECT 34, 'KKMM' FROM dual UNION ALL
                SELECT 35, 'KUTOCHVP' FROM dual UNION ALL
                SELECT 81, 'EOOS' FROM dual UNION ALL
                SELECT 41, 'ESEO' FROM dual UNION ALL
                SELECT 42, 'EE' FROM dual UNION ALL
                SELECT 43, 'ETET' FROM dual UNION ALL
                SELECT 44, 'TIE' FROM dual UNION ALL
                SELECT 45, 'MF' FROM dual UNION ALL
                SELECT 91, 'SPN' FROM dual UNION ALL
                SELECT 54, 'KTT' FROM dual UNION ALL
                SELECT 55, 'ETM' FROM dual UNION ALL
                SELECT 61, 'AP' FROM dual UNION ALL
                SELECT 64, 'KHT' FROM dual UNION ALL
                SELECT 65, 'SIT' FROM dual UNION ALL
                SELECT 75, 'DTK' FROM dual UNION ALL
                SELECT 92, 'KTU' FROM dual UNION ALL
                SELECT 37, 'FVS' FROM dual UNION ALL
                SELECT 53, 'EOPK' FROM dual UNION ALL
                SELECT 63, 'Physics' FROM dual UNION ALL
                SELECT 98, 'DEPOS' FROM dual UNION ALL
                SELECT 62, 'Math' FROM dual
            )
        )
        LOOP
            FOR kurs IN 1..4 LOOP
                FOR i IN 1..2 LOOP
                    IF i = 1 THEN
                        v_podgrupa := 'A';
                    ELSE
                        v_podgrupa := 'B';
                    END IF;

                    FOR groupnum IN 1..5 LOOP
                        INSERT INTO grupi (groupid, name, specid, kurs, education_type, education_type_id)
                        VALUES (
                            v_groupid,
                            rec.shortname || groupnum || v_podgrupa,
                            rec.specid,
                            kurs,
                            v_education_type,
                            v_education_type_id
                        );
                        v_groupid := v_groupid + 1;
                    END LOOP;
                END LOOP;
            END LOOP;
        END LOOP;
    END LOOP;
END;
/

DECLARE
    v_groupid NUMBER := 2401;  -- ???????? ????????? ?? 2401
    v_podgrupa VARCHAR2(1);
    v_group_name VARCHAR2(50);
BEGIN
    FOR et IN (
        SELECT 1 as education_type_id, 'Full-time' as education_type FROM dual
        UNION ALL
        SELECT 2, 'Part-time' FROM dual
    )
    LOOP
        FOR rec IN (
            -- ??? ????? ??????? ? ??????????? ???????????? (specid, shortname)
            SELECT 11 specid, 'TMMM' shortname FROM dual UNION ALL
            SELECT 12, 'MTM' FROM dual
            -- ?????? ????? ??????????? ???????????? ???
        )
        LOOP
            FOR kurs IN 1..2 LOOP -- ???????? ??? 2 ?????
                FOR i IN 1..2 LOOP
                    IF i = 1 THEN
                        v_podgrupa := 'A';
                    ELSE
                        v_podgrupa := 'B';
                    END IF;

                    v_group_name := 'MG' || kurs || v_podgrupa || rec.shortname;

                    INSERT INTO grupi (groupid, name, specid, kurs, education_type, education_type_id)
                    VALUES (
                        v_groupid,
                        v_group_name,
                        rec.specid,
                        kurs,
                        et.education_type,
                        et.education_type_id
                    );

                    v_groupid := v_groupid + 1;
                END LOOP;
            END LOOP;
        END LOOP;
    END LOOP;
END;
/

ALTER TABLE grupi MODIFY (name VARCHAR2(20));


DECLARE
    v_groupid NUMBER := 2417;  -- ????????? ?? ????????? ???????? groupid
    v_podgrupa VARCHAR2(1);
    v_education_type VARCHAR2(10);
    v_education_type_id NUMBER;
    v_group_name VARCHAR2(20);
BEGIN
    FOR et IN (
        SELECT 1 as id, 'Full-time' as txt FROM dual 
        UNION ALL 
        SELECT 2, 'Part-time' FROM dual
    )
    LOOP
        v_education_type_id := et.id;
        v_education_type := et.txt;

        FOR rec IN (
            SELECT specid, shortname FROM (
                SELECT 31 specid, 'IM' shortname FROM dual UNION ALL
                SELECT 13, 'ID' FROM dual UNION ALL
                SELECT 26, 'T' FROM dual UNION ALL
                SELECT 34, 'KKMM' FROM dual UNION ALL
                SELECT 35, 'KUTOCHVP' FROM dual UNION ALL
                SELECT 81, 'EOOS' FROM dual UNION ALL
                SELECT 41, 'ESEO' FROM dual UNION ALL
                SELECT 42, 'EE' FROM dual UNION ALL
                SELECT 43, 'ETET' FROM dual UNION ALL
                SELECT 44, 'TIE' FROM dual UNION ALL
                SELECT 91, 'SPN' FROM dual UNION ALL
                SELECT 54, 'KTT' FROM dual UNION ALL
                SELECT 55, 'ETM' FROM dual UNION ALL
                SELECT 61, 'AP' FROM dual UNION ALL
                SELECT 64, 'KHT' FROM dual UNION ALL
                SELECT 65, 'SIT' FROM dual
            )
        )
        LOOP
            FOR kurs IN 1..2 LOOP
                FOR i IN 1..2 LOOP
                    IF i = 1 THEN
                        v_podgrupa := 'A';
                    ELSE
                        v_podgrupa := 'B';
                    END IF;

                    v_group_name := 'MG' || kurs || v_podgrupa || rec.shortname;

                    INSERT INTO grupi (groupid, name, specid, kurs, education_type, education_type_id)
                    VALUES (
                        v_groupid,
                        v_group_name,
                        rec.specid,
                        kurs,
                        v_education_type,
                        v_education_type_id
                    );

                    v_groupid := v_groupid + 1;
                END LOOP;
            END LOOP;
        END LOOP;
    END LOOP;
END;
/


DECLARE
    v_groupid NUMBER := 2545;  -- ??????? ?? ?????????? ???????? ????????
    v_podgrupa VARCHAR2(1);
    v_education_type VARCHAR2(10);
    v_education_type_id NUMBER;
BEGIN
    -- ????????? ????? ???? ????????
    FOR et IN (
        SELECT 1 as id, 'Full-time' as txt FROM dual 
        UNION ALL 
        SELECT 2, 'Part-time' FROM dual
    )
    LOOP
        v_education_type_id := et.id;
        v_education_type := et.txt;

        -- ???? ??????????????, ????? ????? ?????
        FOR rec IN (
            SELECT * FROM (
                SELECT 66 specid, 'AICCS' shortname FROM dual UNION ALL
                SELECT 67, 'ARUKS' FROM dual UNION ALL
                SELECT 83, 'AE' FROM dual UNION ALL
                SELECT 100, 'BME' FROM dual UNION ALL
                SELECT 101, 'RES' FROM dual UNION ALL
                SELECT 102, 'FPO' FROM dual UNION ALL
                SELECT 103, 'EES' FROM dual UNION ALL
                SELECT 104, 'EERES' FROM dual UNION ALL
                SELECT 105, 'CPDA' FROM dual UNION ALL
                SELECT 106, 'AI' FROM dual UNION ALL
                SELECT 107, 'IE' FROM dual UNION ALL
                SELECT 108, 'ITS' FROM dual
            )
        )
        LOOP
            -- ????????? ????????? ? ??????????
            FOR kurs IN 1..4 LOOP
                FOR i IN 1..2 LOOP
                    v_podgrupa := CASE i WHEN 1 THEN 'A' ELSE 'B' END;

                    FOR groupnum IN 1..5 LOOP
                        INSERT INTO grupi (groupid, name, specid, kurs, education_type, education_type_id)
                        VALUES (
                            v_groupid,
                            rec.shortname || groupnum || v_podgrupa,
                            rec.specid,
                            kurs,
                            v_education_type,
                            v_education_type_id
                        );
                        v_groupid := v_groupid + 1;
                    END LOOP;
                END LOOP;
            END LOOP;
        END LOOP;
    END LOOP;
END;
/



SET SERVEROUTPUT ON;

SET SERVEROUTPUT ON;





DECLARE
    v_studentid NUMBER := 1;
    v_priem NUMBER; -- ?????? ?? ????? (23 ??? 24)
    v_fakultetid NUMBER;
    v_specid NUMBER;
    v_groupid NUMBER;
    v_oks VARCHAR2(20);
    v_oks_digit VARCHAR2(1);
    v_form_na_obuchenie VARCHAR2(20);
    v_form_digit VARCHAR2(1);
    v_education_type_id NUMBER;
    v_facnom VARCHAR2(8);
    v_semesturcount NUMBER;
    v_kurs NUMBER;
    v_fname VARCHAR2(30);
    v_lname VARCHAR2(30);
    v_counter NUMBER := 1; -- ???????? ?????
    v_fak_char VARCHAR2(1);

    v_groupname VARCHAR2(20);

    TYPE t_spec IS TABLE OF specialnosti%ROWTYPE INDEX BY PLS_INTEGER;
    TYPE t_group IS TABLE OF grupi%ROWTYPE INDEX BY PLS_INTEGER;

    v_specs t_spec;
    v_groups t_group;
    v_spec_index NUMBER;
    v_group_index NUMBER;

    TYPE t_fakulteti IS TABLE OF NUMBER;
    v_fakulteti t_fakulteti := t_fakulteti(1, 2, 3, 4, 6, 7, 9, 10);

    v_fak_index NUMBER;
BEGIN
    -- ??????? ?????? ????????????
    SELECT * BULK COLLECT INTO v_specs FROM specialnosti;

    IF v_specs.COUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('???? ????????????!');
        RETURN;
    END IF;

    FOR i IN 1..100 LOOP
        -- ?????? ?? ????? 23 ??? 24 (????????)
        v_priem := CASE WHEN DBMS_RANDOM.VALUE < 0.5 THEN 23 ELSE 24 END;

        -- ????? ?? ???????? ?? ???????
        v_fak_index := TRUNC(DBMS_RANDOM.VALUE(1, v_fakulteti.COUNT + 1));
        v_fakultetid := v_fakulteti(v_fak_index);

        IF v_fakultetid = 10 THEN
            v_fak_char := '0';
        ELSE
            v_fak_char := TO_CHAR(v_fakultetid);
        END IF;

        -- ????? ?? ???????? ???????????
        v_spec_index := TRUNC(DBMS_RANDOM.VALUE(1, v_specs.COUNT + 1));
        v_specid := v_specs(v_spec_index).SPECID;

        -- ??????? ????? ??? ?????????????
        SELECT * BULK COLLECT INTO v_groups FROM grupi WHERE specid = v_specid;

        IF v_groups.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('??????????? ? ID ' || v_specid || ' ???? ?????, ??????????.');
            CONTINUE;
        END IF;

        -- ????? ?? ???????? ?????
        v_group_index := TRUNC(DBMS_RANDOM.VALUE(1, v_groups.COUNT + 1));
        v_groupid := v_groups(v_group_index).GROUPID;
        v_groupname := v_groups(v_group_index).NAME;
        v_kurs := v_groups(v_group_index).KURS;

        -- ?????????? ?? ??? ? ???? ????????
        IF MOD(i, 3) = 0 THEN
            v_oks := 'Bachelor';
            v_oks_digit := '2';
            v_semesturcount := 8;
        ELSE
            v_oks := 'Master';
            v_oks_digit := '5';
            v_semesturcount := 4;
        END IF;

        -- ?????????? ?? ????? ?? ???????? ? ??? ???????????
        IF MOD(i, 2) = 0 THEN
            v_form_na_obuchenie := 'Full-time';
            v_form_digit := '1';
            v_education_type_id := 1;
        ELSE
            v_form_na_obuchenie := 'Part-time';
            v_form_digit := '2';
            v_education_type_id := 2;
        END IF;

        v_fname := 'Student_' || i;
        v_lname := 'Test_' || i;

        -- ????????? facnom
        v_facnom := TO_CHAR(v_priem) || v_fak_char || v_oks_digit || v_form_digit || LPAD(TO_CHAR(v_counter), 3, '0');

        -- ???????? ? students ?????????
        INSERT INTO students (
            studentid, firstname, lastname, facnom,
            form_na_obuchenie, oks, priem, fakultetid,
            specid, groupid, semesturcount, kurs, education_type_id
        ) VALUES (
            v_studentid, v_fname, v_lname, v_facnom,
            v_form_na_obuchenie, v_oks, v_priem, v_fakultetid,
            v_specid, v_groupid, v_semesturcount, v_kurs, v_education_type_id
        );

        DBMS_OUTPUT.PUT_LINE(
            '?????? ??????? ' || v_studentid || ': ' || v_fname || ' ' || v_lname ||
            ', ?????????? ?????: ' || v_facnom ||
            ', ?????: ' || v_groupname
        );

        v_studentid := v_studentid + 1;
        v_counter := v_counter + 1;
        IF v_counter > 999 THEN
            v_counter := 1;
        END IF;
    END LOOP;
END;

DECLARE
    v_studentid NUMBER := 101;  -- starting student ID
    v_priem NUMBER;             -- admission year (23 or 24)
    v_full_year NUMBER;         -- full 4-digit year
    v_current_year NUMBER := 2025;  -- current year
    v_groupid NUMBER;
    v_groupname VARCHAR2(20);
    v_oks VARCHAR2(20);
    v_oks_digit VARCHAR2(1);
    v_form_na_obuchenie VARCHAR2(20);
    v_form_digit VARCHAR2(1);
    v_education_type_id NUMBER;
    v_facnom VARCHAR2(8);
    v_semesturcount NUMBER;
    v_kurs NUMBER;
    v_fname VARCHAR2(30);
    v_lname VARCHAR2(30);
    v_counter NUMBER := 1; -- for unique facnom

    TYPE t_group IS TABLE OF grupi%ROWTYPE INDEX BY PLS_INTEGER;
    v_groups t_group;
    v_group_index NUMBER;
BEGIN
    -- Collect all groups for specid 66
    SELECT * BULK COLLECT INTO v_groups
    FROM grupi
    WHERE specid = 66;

    IF v_groups.COUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No groups found for specid 66!');
        RETURN;
    END IF;

    FOR i IN 1..100 LOOP
        -- Random year of admission (23 = 2023, 24 = 2024)
        v_priem := CASE WHEN DBMS_RANDOM.VALUE < 0.5 THEN 23 ELSE 24 END;

        -- Convert to full year
        v_full_year := 2000 + v_priem;

        -- Randomly select a group
        v_group_index := TRUNC(DBMS_RANDOM.VALUE(1, v_groups.COUNT + 1));
        v_groupid := v_groups(v_group_index).GROUPID;
        v_groupname := v_groups(v_group_index).NAME;

        -- Calculate course and semester based on admission year
        v_kurs := v_current_year - v_full_year + 1;
        v_semesturcount := (v_kurs - 1) * 2 + CASE WHEN MOD(i, 2) = 0 THEN 2 ELSE 1 END;

        -- Determine degree and semester info
        IF MOD(i, 3) = 0 THEN
            v_oks := 'Bachelor';
            v_oks_digit := '2';
        ELSE
            v_oks := 'Master';
            v_oks_digit := '5';
        END IF;

        -- Determine study form (Full-time / Part-time)
        IF MOD(i, 2) = 0 THEN
            v_form_na_obuchenie := 'Full-time';
            v_form_digit := '1';
            v_education_type_id := 1;
        ELSE
            v_form_na_obuchenie := 'Part-time';
            v_form_digit := '2';
            v_education_type_id := 2;
        END IF;

        -- Generate student name
        v_fname := 'Student_' || i;
        v_lname := 'Test_' || i;

        -- Generate facnom (unique student number)
        v_facnom := TO_CHAR(v_priem) || '6' || v_oks_digit || v_form_digit || LPAD(TO_CHAR(v_counter), 3, '0');

        -- Insert student into table
        INSERT INTO students (
            studentid, firstname, lastname, facnom,
            form_na_obuchenie, oks, priem, fakultetid,
            specid, groupid, semesturcount, kurs, education_type_id
        ) VALUES (
            v_studentid, v_fname, v_lname, v_facnom,
            v_form_na_obuchenie, v_oks, v_priem, 6,  -- fakultetid 6 for this spec
            66, v_groupid, v_semesturcount, v_kurs, v_education_type_id
        );

        DBMS_OUTPUT.PUT_LINE('Created student ' || v_studentid || ': ' || v_fname || ' ' || v_lname || ', group: ' || v_groupname || ', kurs: ' || v_kurs || ', semester: ' || v_semesturcount);

        v_studentid := v_studentid + 1;
        v_counter := v_counter + 1;
        IF v_counter > 999 THEN
            v_counter := 1;
        END IF;
    END LOOP;
END;
/






ALTER TABLE katedri MODIFY (name VARCHAR2(100));

INSERT INTO katedri (katedraid, name, fakultetid) VALUES (1, 'Automation of Production', 6);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (2, 'Electronics and Microelectronics', 6);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (3, 'Computer Science and Technologies', 6);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (4, 'Communication Technology and Technologies', 6);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (5, 'Software and Internet Technologies', 6);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (6, 'Materials Science and Technology of Materials', 1);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (7, 'Mechanics and Machine Elements', 1);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (8, 'Transport Technology and Techniques', 1);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (9, 'Ecology and Environmental Protection', 3);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (10, 'Industrial Design', 3);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (11, 'Navigation, Transport Management and Waterway Cleanliness', 3);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (12, 'Shipbuilding, Ship Machines and Mechanisms', 3);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (13, 'Thermal Engineering', 3);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (14, 'Power Supply and Electrical Equipment', 4);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (15, 'Electrical Engineering and Electrotechnologies', 4);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (16, 'Theoretical and Measurement Electrical Engineering', 4);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (17, 'Social and Legal Sciences', 10);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (18, 'Department of Language and Continuing Education and Sport', 10);
UPDATE katedri
SET katedraid = 19
WHERE name = 'Navigation, Transport Management and Waterway Cleanliness';


INSERT INTO katedri (katedraid, name, fakultetid) VALUES (11, 'Technology of Machine Building and Metal Cutting Machines', 1);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (31, 'Industrial Management', 1);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (82, 'Plant Growing', 1);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (42, 'Electrical Engineering', 4);
INSERT INTO katedri (katedraid, name, fakultetid) VALUES (45, 'Mathematics and Physics', 4);

UPDATE katedri
SET name = 'Physical Education and Sport'
WHERE katedraid = 18;

INSERT INTO katedri (katedraid, name, fakultetid) VALUES (53, 'Language Training and Continuing Education Section', 10);






--Automation, Information and Control Computer Systems
-- Semester 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1, 'Mathematics - Part 1', 1, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (2, 'Programming and Computer Use', 1, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (3, 'Electrical Documentation', 1, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (4, 'Economics', 1, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (5, 'Foreign Language - Part 1', 1, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (6, 'Practical Training', 1, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (7, 'Sports - Part 1', 1, 66);

-- Semester 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (8, 'Mathematics - Part 2', 2, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (9, 'Physics', 2, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (10, 'Electronics', 2, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (11, 'Theoretical Electrical Engineering', 2, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (12, 'Foreign Language - Part 2', 2, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (13, 'Practical Training - Part 2', 2, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (14, 'Sports - Part 2', 2, 66);

-- Semester 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (15, 'Electrical Engineering Materials', 3, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (16, 'Electrical Measurements', 3, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (17, 'Technical Mechanics', 3, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (18, 'Electromechanical Devices', 3, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (19, 'Introduction to MATLAB', 3, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (20, 'Sensors in Automation and Robotics', 3, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (21, 'Sports - Part 3', 3, 66);

-- Semester 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (22, 'Control Theory - Part 1', 4, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (23, 'Data and Signal Processing in Automation', 4, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (24, 'Digital Circuitry', 4, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (25, 'Logic Control Systems', 4, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (26, 'Technical Safety', 4, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (27, 'Sports - Part 4', 4, 66);

-- Semester 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (28, 'Control Theory - Part 2', 5, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (29, 'Digital Control Systems', 5, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (30, 'Technical Means for Automation', 5, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (31, 'Embedded Systems', 5, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (32, 'Elective - Control Theory or Digital Control Systems', 5, 66);

-- Semester 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (33, 'Programmable Controllers', 6, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (34, 'System Identification', 6, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (35, 'Electronic Actuators in Automation', 6, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (36, 'Automated Electric Drives', 6, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (37, 'Elective Project - Identification or Automated Drives', 6, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (38, 'Specialized Internship', 6, 66);

-- Semester 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (39, 'Control of Technological Processes', 7, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (40, 'Control of Electromechanical Systems', 7, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (41, 'System Modeling and Optimization', 7, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (42, 'Elective - Industrial Information Systems or Control of Electric Drives', 7, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (43, 'Industrial Communication Systems', 7, 66);

-- Semester 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (44, 'Design of Automation Systems', 8, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (45, 'Elective - CAD Systems or Automation of Renewable Energy Sources', 8, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (46, 'Elective - Building Automation or Adaptive and Robust Control', 8, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (47, 'Intelligent Control Systems', 8, 66);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (48, 'Comprehensive Project', 8, 66);


--Automation, Robotics and Control Computer Systems
-- Semester 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (49, 'Mathematics - Part 1', 1, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (50, 'Physics', 1, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (51, 'Computer Technologies', 1, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (52, 'Technical Documentation', 1, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (53, 'Foreign Language - Part 1', 1, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (54, 'Sports - Part 1', 1, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (55, 'Practical Training - Part 1', 1, 67);

-- Semester 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (56, 'Mathematics - Part 2', 2, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (57, 'Theoretical Electrical Engineering', 2, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (58, 'Electrical Materials', 2, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (59, 'Technical Mechanics', 2, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (60, 'Economics', 2, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (61, 'Foreign Language - Part 2', 2, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (62, 'Sports - Part 2', 2, 67);

-- Semester 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (63, 'Introduction to MATLABS', 3, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (64, 'Electrical Measurements', 3, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (65, 'Electronics - Part 1', 3, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (66, 'Electromechanical Devices', 3, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (67, 'Electronic Technological Devices', 3, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (68, 'Sports - Part 3', 3, 67);

-- Semester 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (69, 'Electronics - Part 2', 4, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (70, 'Control Theory - Part 1', 4, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (71, 'Data and Signal Processing in Automation', 4, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (72, 'Automation Technical Means - Part 1', 4, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (73, 'Logical Control Systems', 4, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (74, 'Practical Training - Part 2', 4, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (75, 'Sports - Part 4', 4, 67);

-- Semester 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (76, 'Control Theory - Part 2', 5, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (77, 'Digital Control Systems', 5, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (78, 'Automation Technical Means - Part 2', 5, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (79, 'Embedded Control Systems', 5, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (80, 'Technical Safety', 5, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (81, 'Elective Project - Control Theory or Digital Control Systems', 5, 67);

-- Semester 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (82, 'System Identification', 6, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (83, 'Programmable Controllers', 6, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (84, 'Automated Electric Drives', 6, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (85, 'Electronic Actuators in Automation', 6, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (86, 'Industrial Communication Networks', 6, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (87, 'Elective Project - System ID or Automated Electric Drives', 6, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (88, 'Specialized Practice', 6, 67);

-- Semester 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (89, 'Control of Technological Processes', 7, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (90, 'Control of Electromechanical Systems', 7, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (91, 'Elective - Modeling and Optimization or Industrial Automation Mechanisms or Robot Control Algorithms', 7, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (92, 'Elective - Industrial Info Systems or Electrical Drive Control or Machine Vision', 7, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (93, 'Elective - Building Automation or RES Automation or Robot Drives', 7, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (94, 'Elective Project - Process Control or Robot Algorithms', 7, 67);

-- Semester 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (95, 'Automation Systems Design', 8, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (96, 'Elective - CAD Systems or Microcontroller Drives or Mobile Robots', 8, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (97, 'Elective - Intelligent Systems or Adaptive and Robust Control or Industrial Robots', 8, 67);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (98, 'Comprehensive Project', 8, 67);

--Automotive Engineering
-- Semester 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (99, 'Mathematics - Part 1', 1, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (100, 'Transport Technology and Organization', 1, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (101, 'Chemistry', 1, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (102, 'Engine and Automobile Operation', 1, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (103, 'English Language', 1, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (104, 'Sports - Part 1', 1, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (105, 'Practical Training - Part 1', 1, 83);

-- Semester 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (106, 'Mathematics - Part 2', 2, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (107, 'Materials Science and Technology', 2, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (108, 'Information Technologies and Systems', 2, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (109, 'Technical Documentation', 2, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (110, 'Technical Mechanics', 2, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (111, 'Sports - Part 2', 2, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (112, 'Practical Training - Part 2', 2, 83);

-- Semester 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (113, 'Strength of Materials', 3, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (114, 'Interchangeability and Technical Measurements', 3, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (115, 'Machine Elements', 3, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (116, 'Fluid Mechanics', 3, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (117, 'Transport Equipment Operational Materials', 3, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (118, 'Sports - Part 3', 3, 83);

-- Semester 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (119, 'Machine Elements - Project', 4, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (120, 'Thermodynamics and Heat Transfer', 4, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (121, 'Electrical Engineering and Electronics', 4, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (122, 'Internal Combustion Engines Theory - Part 1', 4, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (123, 'Transport Equipment Theory', 4, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (124, 'Automated Design Systems in Transport Technology', 4, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (125, 'Sports - Part 4', 4, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (126, 'Specialized Practice', 4, 83);

-- Semester 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (127, 'Electronic Systems in Transport Technology', 5, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (128, 'Internal Combustion Engines Theory - Part 2', 5, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (129, 'Mechanisms and Systems in Internal Combustion Engines', 5, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (130, 'Combined and Alternative Engines', 5, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (131, 'Traffic Safety', 5, 83);

-- Semester 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (132, 'Automobile Design Technology', 6, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (133, 'Automobile Design Technology - Project', 6, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (134, 'Automobile Gas Systems', 6, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (135, 'Economics', 6, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (136, 'Internal Combustion Engines Testing', 6, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (137, 'Fuel Systems and Gasoline Engine Control', 6, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (138, 'Transport Equipment Operation', 6, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (139, 'Specialized Practice', 6, 83);

-- Semester 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (140, 'Transport Equipment Repair', 7, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (141, 'Fuel Systems and Diesel Engine Control', 7, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (142, 'Computer Technologies in Transport Technology', 7, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (143, 'Oscillatory Processes in Automobile Technology', 7, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (144, 'Transport Equipment Construction', 7, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (145, 'Transport Equipment Construction - Project', 7, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (146, 'Technical Safety', 7, 83);

-- Semester 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (147, 'Torsional Vibrations in Automobile Technology', 8, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (148, 'Torsional Vibrations in Automobile Technology - Project', 8, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (149, 'Transport Technology Ecology', 8, 83);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (150, 'Computer Technologies in Automobile Technology', 8, 83);


--Agronomy
-- Semester 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (151, 'Mathematics - Part 1', 1, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (152, 'Transport Technology and Organization', 1, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (153, 'Chemistry', 1, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (154, 'Engine and Vehicle Operation', 1, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (155, 'English Language', 1, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (156, 'Sports - Part 1', 1, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (157, 'Practical Training - Part 1', 1, 82);

-- Semester 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (158, 'Mathematics - Part 2', 2, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (159, 'Materials Science and Technology', 2, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (160, 'Information Technologies and Systems', 2, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (161, 'Technical Documentation', 2, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (162, 'Technical Mechanics', 2, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (163, 'Sports - Part 2', 2, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (164, 'Practical Training - Part 2', 2, 82);

-- Semester 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (165, 'Strength of Materials', 3, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (166, 'Interchangeability and Technical Measurements', 3, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (167, 'Machine Elements', 3, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (168, 'Fluid Mechanics', 3, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (169, 'Operational Materials in Transport Technology', 3, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (170, 'Sports - Part 3', 3, 82);

-- Semester 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (171, 'Machine Elements - Project', 4, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (172, 'Thermodynamics and Heat Transfer', 4, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (173, 'Electrical Engineering and Electronics', 4, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (174, 'Internal Combustion Engine Theory - Part 1', 4, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (175, 'Transport Technology Theory', 4, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (176, 'Automated Design Systems in Transport Technology', 4, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (177, 'Sports - Part 4', 4, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (178, 'Specialized Practice', 4, 82);

-- Semester 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (179, 'Electronic Systems in Transport Technology', 5, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (180, 'Internal Combustion Engine Theory - Part 2', 5, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (181, 'Mechanisms and Systems in Internal Combustion Engines', 5, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (182, 'Combined and Alternative Engines', 5, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (183, 'Traffic Safety', 5, 82);

-- Semester 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (184, 'Automotive Design Technology', 6, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (185, 'Automotive Design Technology - Project', 6, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (186, 'Automotive Gas Systems', 6, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (187, 'Economics', 6, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (188, 'Internal Combustion Engine Testing', 6, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (189, 'Fuel Systems and Gasoline Engine Control', 6, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (190, 'Transport Equipment Operation', 6, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (191, 'Specialized Practice', 6, 82);

-- Semester 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (192, 'Transport Equipment Repair', 7, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (193, 'Fuel Systems and Diesel Engine Control', 7, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (194, 'Computer Technologies in Transport Technology', 7, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (195, 'Oscillatory Processes in Automotive Technology', 7, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (196, 'Transport Equipment Construction', 7, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (197, 'Transport Equipment Construction - Project', 7, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (198, 'Technical Safety', 7, 82);

-- Semester 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (199, 'Torsional Vibrations in Automotive Technology', 8, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (200, 'Torsional Vibrations in Automotive Technology - Project', 8, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (201, 'Ecology of Transport Technology', 8, 82);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (202, 'Computer Technologies in Automotive Technology', 8, 82);


--Biomedical Electronics
-- Semester 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (203, 'Mathematics – Part 1', 1, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (204, 'Programming and Computer Usage', 1, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (205, 'Electrical Engineering Documentation', 1, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (206, 'Standards in Electronics', 1, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (207, 'Foreign Language – Part 1', 1, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (208, 'Practical Training – Part 1', 1, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (209, 'Specialized Sports Training – Part 1', 1, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (210, 'Sports and Social Adaptation – Part 1', 1, 100);

-- Semester 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (211, 'Mathematics – Part 2', 2, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (212, 'Physics', 2, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (213, 'Electronics', 2, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (214, 'Theoretical Electrical Engineering', 2, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (215, 'Foreign Language – Part 2', 2, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (216, 'Practical Training – Part 2', 2, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (217, 'Specialized Sports Training – Part 2', 2, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (218, 'Sports and Social Adaptation – Part 2', 2, 100);

-- Semester 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (219, 'Electrical Engineering Materials', 3, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (220, 'Electrical Measurements', 3, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (221, 'Technical Mechanics', 3, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (222, 'Electromechanical Devices', 3, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (223, 'Introduction to MATLAB', 3, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (224, 'Design of Electronic Equipment', 3, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (225, 'Specialized Sports Training – Part 3', 3, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (226, 'Sports Management – Part 1', 3, 100);

-- Semester 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (227, 'Fundamentals of Automatic Control', 4, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (228, 'Digital Circuitry', 4, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (229, 'Analysis and Synthesis of Electronic Circuits', 4, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (230, 'Information and Signal Theory', 4, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (231, 'Technical Safety', 4, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (232, 'Specialized Sports Training – Part 4', 4, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (233, 'Sports Management – Part 2', 4, 100);

-- Semester 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (234, 'Analog Circuitry', 5, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (235, 'Testing and Verification of Electronic Devices', 5, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (236, 'Microprocessor Systems – Part 1', 5, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (237, 'Computer-Aided Electronics Design', 5, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (238, 'Power Supply Devices', 5, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (239, 'Elective Project: Analysis and Synthesis of Electronic Circuits', 5, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (240, 'Elective Project: Design of Electronic Equipment', 5, 100);

-- Semester 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (241, 'Conversion Technology', 6, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (242, 'Microprocessor Systems – Part 2', 6, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (243, 'Bioelectrical and Physiological Measurements in Humans', 6, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (244, 'Programming for Hardware Design', 6, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (245, 'Communication and Internet Technologies', 6, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (246, 'Elective Project: Computer-Aided Electronics Design', 6, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (247, 'Elective Project: Analog Circuitry', 6, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (248, 'Specializing Practice', 6, 100);

-- Semester 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (249, 'Digital Signal Processing', 7, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (250, 'Sensor Technology', 7, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (251, 'Industrial Electronics', 7, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (252, 'Biophysics and Biomechanics', 7, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (253, 'Imaging Diagnostic Equipment', 7, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (254, 'Elective Project: Microprocessor Systems – Part 2', 7, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (255, 'Elective Project: Conversion Technology', 7, 100);

-- Semester 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (256, 'Medical Electronic Equipment', 8, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (257, 'Acquisition and Processing of Biomedical Signals', 8, 100);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (258, 'Acquisition and Processing of Biomedical Images', 8, 100);


--Renewable Energy Sources
-- Semester 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (259, 'Mathematics – Part 1', 1, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (260, 'Programming and Computer Usage', 1, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (261, 'Electrical Documentation', 1, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (262, 'Materials Science Practicum', 1, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (263, 'Foreign Language – Part 1', 1, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (264, 'Elective Subject: Specialized Sports Training – Part 1', 1, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (265, 'Elective Subject: Sport and Social Adaptation – Part 1', 1, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (266, 'Practical Training – Part 1', 1, 101);

-- Semester 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (267, 'Mathematics – Part 2', 2, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (268, 'Physics', 2, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (269, 'Electronics', 2, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (270, 'Theoretical Electrical Engineering – Part 1', 2, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (271, 'Foreign Language – Part 2', 2, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (272, 'Introduction to Renewable Energy Sources', 2, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (273, 'Practical Training – Part 2', 2, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (274, 'Elective Subject: Specialized Sports Training – Part 2', 2, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (275, 'Elective Subject: Sport and Social Adaptation – Part 2', 2, 101);

-- Semester 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (276, 'Electrical Engineering Materials', 3, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (277, 'Electrical Measurements', 3, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (278, 'Technical Mechanics', 3, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (279, 'Theoretical Electrical Engineering – Part 2', 3, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (280, 'Introduction to MATLAB', 3, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (281, 'Thermodynamics and Heat Transfer', 3, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (282, 'Practical Training – Part 3', 3, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (283, 'Elective Subject: Specialized Sports Training – Part 3', 3, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (284, 'Elective Subject: Sports Management – Part 1', 3, 101);

-- Semester 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (285, 'Fundamentals of Automatic Control', 4, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (286, 'Basic Course on Renewable Energy Sources', 4, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (287, 'Hydraulics and Pneumatics', 4, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (288, 'Machine Elements', 4, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (289, 'Heat Exchange Equipment for Renewable Energy Systems', 4, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (290, 'Industrial Chemistry', 4, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (291, 'Elective Subject: Specialized Sports Training – Part 4', 4, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (292, 'Elective Subject: Sports Management – Part 2', 4, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (293, 'Practical Training – Part 4', 4, 101);

-- Semester 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (294, 'Special Course on Renewable Energy Sources', 5, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (295, 'Hydrokinetic and Cogeneration Systems', 5, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (296, 'Photovoltaic Installations and Solar Power Plants', 5, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (297, 'Electrical Machines – Part 1', 5, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (298, 'Electrical Apparatus – Part 1', 5, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (299, 'Power Electronics', 5, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (300, 'Elective Subject: Lighting Installations', 5, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (301, 'Elective Subject: Energy Security', 5, 101);

-- Semester 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (302, 'Electrical Machines – Part 2', 6, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (303, 'Electrical Apparatus – Part 2', 6, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (304, 'Technical Safety', 6, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (305, 'Heating Installations with Renewable Energy Sources', 6, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (306, 'Relay Protection', 6, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (307, 'Elective Subject: Lighting Installations', 6, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (308, 'Elective Subject: Energy Security', 6, 101);

-- Semester 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (309, 'Specialized Practice', 7, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (310, 'Sensor Technology', 7, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (311, 'Elective Project: Design of Renewable Energy Systems – Photovoltaics', 7, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (312, 'Elective Subject: Project: Heating Installations with Renewable Energy Sources', 7, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (313, 'Electrical Micromachines', 7, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (314, 'Electrical Apparatus – Part 3', 7, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (315, 'Wind Facilities and Systems', 7, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (316, 'Electromechanical Systems', 7, 101);

-- Semester 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (317, 'Operation, Diagnostics and Repair of Electrical Equipment for Renewable Energy Sources', 8, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (318, 'Elective Subject: Automation Systems for Renewable Energy Sources', 8, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (319, 'Programmable Controllers', 8, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (320, 'Protection, Conservation and Reproduction of the Environment', 8, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (321, 'Elective Subject: Electronic Systems for Renewable Energy Sources', 8, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (322, 'Electrotechnological Devices for Environmental Purposes', 8, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (323, 'Production Management', 8, 101);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (324, 'Testing and Reliability in Renewable Energy Sources', 8, 101);

--Fleet and Port Operations
--Semestur 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (325, 'Higher Mathematics – Part 1', 1, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (326, 'Computer Science and Computer Technology', 1, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (327, 'Labour Protection and Technical Safety', 1, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (328, 'Engineering Graphics', 1, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (329, 'Elective: Specialized Sports Training – Part 1 or Sport and Social Adaptation – Part 1', 1, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (330, 'English – Part 1', 1, 102);

--Semestur 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (331, 'Higher Mathematics – Part 2', 2, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (332, 'Elective: Labor Legislation or Basics of Law', 2, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (333, 'Technical Mechanics', 2, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (334, 'Physics', 2, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (335, 'Economics', 2, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (336, 'Elective: Specialized Sports Training – Part 2 or Sport and Social Adaptation – Part 2', 2, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (337, 'English – Part 2', 2, 102);

--Semestur 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (338, 'Higher Mathematics – Part 3', 3, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (339, 'Elective: Labor Legislation or Basics of Law', 3, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (340, 'Technical Mechanics', 3, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (341, 'Physics', 3, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (342, 'Economics', 3, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (343, 'Elective: Specialized Sports Training – Part 3 or Sports Management – Part 1', 3, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (344, 'English – Part 3', 3, 102);

--Semestur 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (345, 'Commodity Science', 4, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (346, 'Machine Science', 4, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (347, 'Elective: Labor Legislation or Basics of Law', 4, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (348, 'Port Structure', 4, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (349, 'Meteorology', 4, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (350, 'Elective: Transport Marketing or Transport Management', 4, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (351, 'English – Part 4', 4, 102);

--Semestur 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (352, 'Transport Equipment', 5, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (353, 'English – Part 5', 5, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (354, 'Marine Transport Technology', 5, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (355, 'Maritime Law', 5, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (356, 'Port Technologies', 5, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (357, 'Reporting and Analysis of Operational Activity', 5, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (358, 'Elective: Specialized Sports Training – Part 4 or Sports Management – Part 2', 5, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (359, 'Specialized Internship – Part 1', 5, 102);

--Semestur 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (360, 'Organization and Management of Ports', 6, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (361, 'Commercial Operation of Fleet and Ports', 6, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (362, 'Technical Operation of Fleet and Ports', 6, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (363, 'Customs Control', 6, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (364, 'English – Part 6', 6, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (365, 'Specialized Internship – Part 2', 6, 102);

--Semestur 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (366, 'Ship Mechanization and Cargo Handling', 7, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (367, 'Transport Logistics', 7, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (368, 'Intermodal Transport Interaction', 7, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (369, 'Port Management under Special Conditions', 7, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (370, 'English – Part 7', 7, 102);

--Semestur 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (371, 'English – Part 8', 8, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (372, 'Electives: Sea Routes Geography, World Economy, Business Communication, Ethics, etc.', 8, 102);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (373, 'State Exam Preparation', 8, 102);


--Power Engineering
--semester 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (374, 'Mathematics Part 1', 1, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (375, 'Programming and Computer Usage', 1, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (376, 'Technical Mechanics', 1, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (377, 'Electrical Engineering Documentation', 1, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (378, 'Foreign Language Part 1', 1, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (379, 'Training Practice Part 1', 1, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (380, 'Elective Course', 1, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (381, 'Specialized Sports Training Part 1', 1, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (382, 'Sports and Social Adaptation Part 1', 1, 42);

--semester 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (383, 'Mathematics Part 2', 2, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (384, 'Theoretical Electrical Engineering Part 1', 2, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (385, 'Physics', 2, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (386, 'Electronics', 2, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (387, 'Hydraulics and Pneumatics', 2, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (388, 'Electrical Engineering Materials', 2, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (389, 'Foreign Language Part 2', 2, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (390, 'Training Practice Part 2', 2, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (391, 'Elective Course', 2, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (392, 'Specialized Sports Training Part 2', 2, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (393, 'Sports and Social Adaptation Part 2', 2, 42);

--semester 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (394, 'Theoretical Electrical Engineering Part 2', 3, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (395, 'Electrical Measurements', 3, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (396, 'Thermal Power Engineering', 3, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (397, 'Electrical Machines and Devices Part 1', 3, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (398, 'Foreign Language Part 3', 3, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (399, 'Training Practice Part 3', 3, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (400, 'Elective Course', 3, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (401, 'Specialized Sports Training Part 3', 3, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (402, 'Sports Management Part 1', 3, 42);

--semester 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (403, 'Lighting and Installation Technology', 4, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (404, 'Digital and Microprocessor Technology', 4, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (405, 'Electrical Machines and Devices Part 2', 4, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (406, 'Modeling in Power Systems', 4, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (407, 'Mechanical Part of Electrical Networks', 4, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (408, 'Training Practice Part 4', 4, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (409, 'Elective Course', 4, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (410, 'Specialized Sports Training Part 4', 4, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (411, 'Sports Management Part 2', 4, 42);

--semester 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (412, 'Electricity Production Technology', 5, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (413, 'Electrical Networks and Systems', 5, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (414, 'Mechanical Part of Electrical Networks Project', 5, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (415, 'Short Circuits in Power Systems', 5, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (416, 'Technical Safety', 5, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (417, 'Electrical Part of Power Plants and Substations', 5, 42);

--semester 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (418, 'Electrical Networks and Systems Project', 6, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (419, 'Electrical Networks in Settlements', 6, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (420, 'Remote Control in Power Systems', 6, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (421, 'Electrical Part of Power Plants and Substations Project', 6, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (422, 'Relay Protection', 6, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (423, 'Elective Course', 6, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (424, 'Grounding and Lightning Protection Installations', 6, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (425, 'Management', 6, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (426, 'Enterprise Economics', 6, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (427, 'Special Practice', 6, 42);

--semester 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (428, 'Power Systems Stability', 7, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (429, 'High Voltage Technology', 7, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (430, 'Construction of Power Objects', 7, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (431, 'Remote Control in Power Systems Project', 7, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (432, 'Power Systems Automation', 7, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (433, 'Elective Course', 7, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (434, 'Testing of Electrical Insulation Systems', 7, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (435, 'Fundamentals of State and Law', 7, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (436, 'Fundamentals of Management', 7, 42);

-- semester 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (437, 'Computer Research in Power Systems', 8, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (438, 'Digital Relay Protection', 8, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (439, 'Digital Relay Protection Project', 8, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (440, 'Cable Diagnostics of Electrical Conductors', 8, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (441, 'Organizational Psychology and Work Psychology', 8, 42);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (442, 'Creativity and Methods for Generating New Ideas', 8, 42);



-- Electronics
-- semester 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (443, 'Mathematics – Part 1', 1, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (444, 'Programming and Computer Use', 1, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (445, 'Electrical Documentation', 1, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (446, 'Standards in Electronics', 1, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (447, 'Foreign Language – Part 1', 1, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (448, 'Training Practice – Part 1', 1, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (449, 'Elective: Specialized Sports Training / Social Adaptation through Sports', 1, 43);

-- semester 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (450, 'Mathematics – Part 2', 2, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (451, 'Physics', 2, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (452, 'Electronics', 2, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (453, 'Theoretical Electrical Engineering', 2, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (454, 'Foreign Language – Part 2', 2, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (455, 'Training Practice – Part 2', 2, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (456, 'Elective: Specialized Sports Training / Social Adaptation through Sports', 2, 43);

-- semester 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (457, 'Electrical Engineering Materials', 3, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (458, 'Electrical Measurements', 3, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (459, 'Technical Mechanics', 3, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (460, 'Electromechanical Devices', 3, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (461, 'Introduction to MATLAB', 3, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (462, 'Design of Electronic Equipment', 3, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (463, 'Elective: Specialized Sports Training / Sports Management', 3, 43);

-- semester 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (464, 'Basics of Automatic Control', 4, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (465, 'Digital Circuitry', 4, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (466, 'Analysis and Synthesis of Electronic Circuits', 4, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (467, 'Theory of Information and Signals', 4, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (468, 'Technical Safety', 4, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (469, 'Elective: Specialized Sports Training / Sports Management', 4, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (470, 'Analog Circuitry', 4, 43);

-- semester 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (471, 'Testing and Verification of Electronic Devices', 5, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (472, 'Microprocessor Systems – Part 1', 5, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (473, 'Computer-Aided Design in Electronics', 5, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (474, 'Power Supply Devices', 5, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (475, 'Elective Project: Circuit Analysis / Equipment Design', 5, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (476, 'Converter Technology', 5, 43);

-- semester 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (477, 'Microprocessor Systems – Part 2', 6, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (478, 'Measuring Electronics', 6, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (479, 'Programming for Hardware Design', 6, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (480, 'Communication and Internet Technologies', 6, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (481, 'Elective Project: Computer-Aided Design / Analog Circuitry', 6, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (482, 'Specialized Practice', 6, 43);

-- semester 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (483, 'Digital Signal Processing', 7, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (484, 'Sensor Technology', 7, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (485, 'Industrial Electronics', 7, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (486, 'Automotive Electronics', 7, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (487, 'Elective: Microelectronics / Imaging Diagnostics Equipment', 7, 43);

-- semester 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (488, 'Elective Project: Microprocessor Systems / Converter Technology', 8, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (489, 'Medical Electronic Equipment', 8, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (490, 'Elective: Intelligent Electronic Systems / Biomedical Signal Processing', 8, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (491, 'Elective: Renewable Energy Electronic Systems / Biomedical Image Processing', 8, 43);


--Electrical Equipment of the Ship
-- semester 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (492, 'Mathematics – Part 1', 1, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (493, 'Technical Mechanics', 1, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (494, 'Electrical Documentation', 1, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (495, 'English Language – Part 1', 1, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (496, 'Training Practice – Part 1', 1, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (497, 'Elective: Specialized Sports Training – Part 1', 1, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (498, 'Elective: Adapted Physical Activity', 1, 103);

-- semester 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (499, 'Physics', 2, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (500, 'Theoretical Electrical Engineering – Part 1', 2, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (501, 'Ship Theory and Construction', 2, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (502, 'Electrical Materials', 2, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (503, 'Industrial Chemistry', 2, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (504, 'English Language – Part 2', 2, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (505, 'Training Practice – Part 2', 2, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (506, 'Elective: Specialized Sports Training – Part 2', 2, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (507, 'Elective: Adapted Physical Activity', 2, 103);

-- semester 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (508, 'Theoretical Electrical Engineering – Part 2', 3, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (509, 'Electrical Measurements', 3, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (510, 'Thermodynamics and Heat Transfer', 3, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (511, 'Electrical Machines and Devices – Part 1', 3, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (512, 'Computer-Aided Design', 3, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (513, 'English Language – Part 3', 3, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (514, 'Training Practice – Part 3', 3, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (515, 'Elective: Specialized Sports Training – Part 3', 3, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (516, 'Elective: Adapted Physical Activity', 3, 103);

-- semester 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (517, 'Basics of Automation', 4, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (518, 'Digital and Microprocessor Technology', 4, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (519, 'Electrical Machines and Devices – Part 2', 4, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (520, 'Ship Power Electronics – Part 1', 4, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (521, 'Hydraulics and Pneumatics', 4, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (522, 'Specialized English Language – Part 1', 4, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (523, 'Training Practice – Part 4', 4, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (524, 'Elective: Specialized Sports Training – Part 4', 4, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (525, 'Elective: Adapted Physical Activity', 4, 103);

-- semester 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (526, 'Ship Electronic and Microprocessor Systems', 5, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (527, 'Ship Power Electronics – Part 2', 5, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (528, 'Ship Machines, Mechanisms, Systems, and Devices', 5, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (529, 'Maritime Law', 5, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (530, 'Specialized English Language – Part 2', 5, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (531, 'Technical Safety', 5, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (532, 'Training Practice – Part 5', 5, 103);

-- semester 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (533, 'Elements of Ship Automation', 6, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (534, 'Electric Power Stations on Specialized Floating Objects', 6, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (535, 'Ship Electric Power Systems – Part 1', 6, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (536, 'Operation of Ship Electronic and Electrical Equipment – Part 1', 6, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (537, 'Specialized English Language – Part 3', 6, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (538, 'Training Practice – Part 6', 6, 103);

-- semester 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (539, 'Ship Electric Power Systems – Part 2', 7, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (540, 'Electric Drive and Propulsion of the Ship – Part 1', 7, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (541, 'High Voltage Technology', 7, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (542, 'Ship Electric Power Systems – Project', 7, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (543, 'Specialized English Language – Part 4', 7, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (544, 'Training Technology and Simulator Practice', 7, 103);

-- semester 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (545, 'Comprehensive Ship Automation', 8, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (546, 'Electric Drive and Propulsion of the Ship – Part 2', 8, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (547, 'Installation, Maintenance, Diagnostics, and Repair of Ship Electrical Equipment', 8, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (548, 'Operation of Ship Electronic and Electrical Equipment – Part 2', 8, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (549, 'Specialized English Language – Part 5', 8, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (550, 'Elective: Shipboard Practice', 8, 103);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (551, 'Elective: Industrial Training Practice', 8, 103);


--Power Supply and Electrical Equipment
-- semester 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (552, 'Mathematics - Part 1', 1, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (553, 'Programming and Computer Usage', 1, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (554, 'Technical Mechanics', 1, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (555, 'Electrical Engineering Documentation', 1, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (556, 'Foreign Language - Part 1', 1, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (557, 'Practical Training - Part 1', 1, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (558, 'Elective: Specialized Sports Training - Part 1 / Sports and Social Adaptation - Part 1', 1, 41);


-- semester 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (559, 'Mathematics - Part 2', 2, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (560, 'Physics', 2, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (561, 'Theoretical Electrical Engineering - Part 1', 2, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (562, 'Electronics', 2, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (563, 'Hydraulics and Pneumatics', 2, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (564, 'Electrical Engineering Materials', 2, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (565, 'Foreign Language - Part 2', 2, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (566, 'Practical Training - Part 2', 2, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (567, 'Elective: Specialized Sports Training - Part 2 / Sports and Social Adaptation - Part 2', 2, 41);


-- semester 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (568, 'Theoretical Electrical Engineering - Part 2', 3, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (569, 'Electrical Measurements', 3, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (570, 'Electrical Machines and Apparatus - Part 1', 3, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (571, 'Thermal Power Engineering', 3, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (572, 'Machine Elements and Mechanisms', 3, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (573, 'CAD Systems in Power Supply and Electrical Equipment', 3, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (574, 'Foreign Language - Part 3', 3, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (575, 'Practical Training - Part 3', 3, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (576, 'Elective: Specialized Sports Training - Part 3 / Sports Management - Part 1', 3, 41);


-- semester 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (577, 'Electrical Machines and Apparatus - Part 2', 4, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (578, 'Digital and Microprocessor Technology', 4, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (579, 'Lighting and Installation Technology', 4, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (580, 'Electric Drives', 4, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (581, 'Industrial Converters in Electrical Equipment - Part 1', 4, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (582, 'Practical Training - Part 4', 4, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (583, 'Elective: Specialized Sports Training - Part 4 / Sports Management - Part 2', 4, 41);

-- semester 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (584, 'Power Supply - Part 1', 5, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (585, 'Industrial Converters in Electrical Equipment - Part 2', 5, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (586, 'Electrical Part of Power Plants and Substations', 5, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (587, 'Electrical Part of Power Plants and Substations - Project', 5, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (588, 'High Voltage Technology', 5, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (589, 'Technical Safety', 5, 41);


-- semester 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (590, 'Power Supply - Part 2', 6, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (591, 'Electrical Equipment - Part 1', 6, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (592, 'Lighting Installations', 6, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (593, 'Automated Electric Drives', 6, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (594, 'Relay Protection', 6, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (595, 'Elective: Operation and Diagnostics of Electrical Installations or Law or Labor Risk Mgmt', 6, 41);


-- semester 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (597, 'Electrical Equipment - Part 2', 7, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (598, 'Electronic and Microprocessor Systems for Industrial Equipment Control', 7, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (599, 'Electric Transport', 7, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (600, 'Elective: Transient Processes in Electrical Equipment / Labor Law / Production Management', 7, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (601, 'Elective: Lighting Control or Industrial Law or Industrial Eng.', 7, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (602, 'Electrical Equipment - Project', 7, 41);

-- semester 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (603, 'Computer Methods for Design and Research in Power Supply and Electrical Equipment', 8, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (604, 'Elective: Electrical Equip. Prod. or Entrepreneurship or HR Management', 8, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (605, 'Elective: Energy Efficiency / Energy Economy Organization / Quality Management', 8, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (606, 'Power Supply - Project', 8, 41);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (607, 'Pre-Diploma Internship in the Specialty', 8, 41);


--Electrical Engineering and Renewable Energy Sources
-- semester 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (608, 'Mathematics - Part 1', 1, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (609, 'Programming and Computer Usage', 1, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (610, 'Technical Mechanics', 1, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (611, 'Electrical Engineering Documentation', 1, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (612, 'Foreign Language - Part 1', 1, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (613, 'Practical Training - Part 1', 1, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (614, 'Elective: Specialized Sports Training - Part 1 / Sports and Social Adaptation - Part 1', 1, 104);

-- semester 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (615, 'Mathematics - Part 2', 2, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (616, 'Physics', 2, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (617, 'Theoretical Electrical Engineering - Part 1', 2, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (618, 'Electronics', 2, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (619, 'Hydraulics and Pneumatics', 2, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (620, 'Electrical Engineering Materials', 2, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (621, 'Foreign Language - Part 2', 2, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (622, 'Practical Training - Part 2', 2, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (623, 'Elective: Specialized Sports Training - Part 2 / Sports and Social Adaptation - Part 2', 2, 104);

-- semester 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (624, 'Theoretical Electrical Engineering - Part 2', 3, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (625, 'Electrical Measurements', 3, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (626, 'Electrical Machines and Apparatus - Part 1', 3, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (627, 'Thermal Power Engineering', 3, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (628, 'Machine Elements and Mechanisms', 3, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (629, 'CAD Systems in Power Supply and Electrical Equipment', 3, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (630, 'Foreign Language - Part 3', 3, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (631, 'Practical Training - Part 3', 3, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (632, 'Elective: Specialized Sports Training - Part 3 / Sports Management - Part 1', 3, 104);

-- semester 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (633, 'Electrical Machines and Apparatus - Part 2', 4, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (634, 'Digital and Microprocessor Technology', 4, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (635, 'Lighting and Installation Technology', 4, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (636, 'Electric Drives', 4, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (637, 'Industrial Converters in Electrical Equipment - Part 1', 4, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (638, 'Practical Training - Part 4', 4, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (639, 'Elective: Specialized Sports Training - Part 4 / Sports Management - Part 2', 4, 104);

-- semester 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (640, 'Power Supply - Part 1', 5, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (641, 'Industrial Converters in Electrical Equipment - Part 2', 5, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (642, 'Electrical Part of Power Plants and Substations', 5, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (643, 'Electrical Part of Power Plants and Substations - Project', 5, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (644, 'High Voltage Technology', 5, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (645, 'Technical Safety', 5, 104);

-- semester 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (646, 'Power Supply - Part 2', 6, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (647, 'Electrical Equipment - Part 1', 6, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (648, 'Lighting Installations', 6, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (649, 'Automated Electric Drives', 6, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (650, 'Relay Protection', 6, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (651, 'Elective: Operation and Diagnostics of Electrical Installations or Law or Labor Risk Mgmt', 6, 104);

-- semester 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (652, 'Electrical Equipment - Part 2', 7, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (653, 'Electronic and Microprocessor Systems for Industrial Equipment Control', 7, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (654, 'Electric Transport', 7, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (655, 'Elective: Transient Processes in Electrical Equipment / Labor Law / Production Management', 7, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (656, 'Elective: Lighting Control or Industrial Law or Industrial Eng.', 7, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (657, 'Electrical Equipment - Project', 7, 104);

-- semester 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (658, 'Computer Methods for Design and Research in Power Supply and Electrical Equipment', 8, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (659, 'Elective: Electrical Equip. Prod. or Entrepreneurship or HR Management', 8, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (660, 'Elective: Energy Efficiency / Energy Economy Organization / Quality Management', 8, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (661, 'Power Supply - Project', 8, 104);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (662, 'Pre-Diploma Internship in the Specialty', 8, 104);


--Electrical Engineering and Electrotechnologies
-- Semester 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (663, 'Mathematics - Part 1', 1, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (664, 'Programming and Computer Usage', 1, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (665, 'Electrical Engineering Documentation', 1, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (666, 'Materials Science Practical', 1, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (667, 'Foreign Language - Part 1', 1, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (668, 'Elective Course', 1, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (669, 'Specialized Sports Training - Part 1', 1, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (670, 'Sports and Social Adaptation - Part 1', 1, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (671, 'Practical Training - Part 1', 1, 43);

-- Semester 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (672, 'Mathematics - Part 2', 2, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (673, 'Physics', 2, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (674, 'Electronics', 2, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (675, 'Theoretical Electrical Engineering - Part 1', 2, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (676, 'Foreign Language - Part 2', 2, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (677, 'Introduction to Electrotechnologies and Nanotechnologies', 2, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (678, 'Practical Training - Part 2', 2, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (679, 'Elective Course', 2, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (680, 'Specialized Sports Training - Part 2', 2, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (681, 'Sports and Social Adaptation - Part 2', 2, 43);

-- Semester 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (682, 'Electrical Engineering Materials', 3, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (683, 'Electrical Measurements', 3, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (684, 'Technical Mechanics', 3, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (685, 'Theoretical Electrical Engineering - Part 2', 3, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (686, 'Introduction to MATLAB', 3, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (687, 'Practical Training - Part 3', 3, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (688, 'Elective Course', 3, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (689, 'Specialized Sports Training - Part 3', 3, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (690, 'Sports Management - Part 1', 3, 43);

-- Semester 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (691, 'Fundamentals of Automatic Control', 4, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (692, 'Basic Course in Renewable Energy Sources', 4, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (693, 'Hydraulics and Pneumatics', 4, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (694, 'Machine Elements', 4, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (695, 'Electrotechnologies - Part 1', 4, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (696, 'Industrial Chemistry', 4, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (697, 'Elective Course', 4, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (698, 'Specialized Sports Training - Part 4', 4, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (699, 'Sports Management - Part 2', 4, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (700, 'Practical Training - Part 4', 4, 43);

-- Semester 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (701, 'Electrotechnologies - Part 2', 5, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (702, 'Electrothermy', 5, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (703, 'Household Electrical Appliances', 5, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (704, 'Electrical Machines - Part 1', 5, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (705, 'Electrical Apparatus - Part 1', 5, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (706, 'Power Conversion Technology', 5, 43);

-- Semester 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (707, 'Electrical Machines - Part 2', 6, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (708, 'Electrical Apparatus - Part 2', 6, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (709, 'Technical Safety', 6, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (710, 'Computer Modeling of Electrotechnical Devices and Technologies', 6, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (711, 'Elective Course', 6, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (712, 'Lighting Installations', 6, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (713, 'Programmable Controllers', 6, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (714, 'Communication and Internet Technologies', 6, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (715, 'Specialized Internship', 6, 43);

-- Semester 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (716, 'Electric Vehicles', 7, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (717, 'Elective Course - Project', 7, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (718, 'Design of Electromechanical Systems', 7, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (719, 'Design of Electrotechnological Devices', 7, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (720, 'Electrical Micromachines', 7, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (721, 'Electrical Apparatus - Part 3', 7, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (722, 'Electromechanical Systems', 7, 43);

-- Semester 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (723, 'Operation, Diagnostics, and Repair of Electrotechnical Equipment', 8, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (724, 'Electrical Systems in Automobiles', 8, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (725, 'Elective Course', 8, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (726, 'Electrotechnological Devices for Environmental Purposes', 8, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (727, 'Production Management', 8, 43);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (728, 'Testing and Reliability in Electrical Engineering', 8, 43);



--Civil Protection in Disasters and Accidents
-- Semester 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (729, 'Mathematics', 1, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (730, 'Chemistry', 1, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (731, 'Computer Science', 1, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (732, 'English - Part 1', 1, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (733, 'Elective: Sports Training 1 / Social Adaptation 1', 1, 105);

-- Semester 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (734, 'Technical Mechanics', 2, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (735, 'Materials Science', 2, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (736, 'Engineering Graphics', 2, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (737, 'Gen and Extreme Psychology', 2, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (738, 'Sociology', 2, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (739, 'Natural Disasters', 2, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (740, 'English - Part 2', 2, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (741, 'Elective: Sports Training 2 / Social Adaptation 2', 2, 105);

-- Semester 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (742, 'Physics', 3, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (743, 'Electrical Engineering', 3, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (744, 'Statistics', 3, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (745, 'Harmful Environmental Factors', 3, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (746, 'Cutting and Welding Tech', 3, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (747, 'English - Part 3', 3, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (748, 'Elective: Sports Training 3 / Sports Management 1', 3, 105);

-- Semester 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (749, 'Thermodynamics and Heat', 4, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (750, 'Hazardous Chemicals', 4, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (751, 'Fire Safety Regulations', 4, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (752, 'Elective: Meteorology / Geography', 4, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (753, 'English - Part 4', 4, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (754, 'Elective: Sports Training 4 / Sports Management 2', 4, 105);

-- Semester 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (755, 'Workplace Safety and Quality', 5, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (756, 'Critical Situations and Hazards', 5, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (757, 'Disaster Damage Assessment', 5, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (758, 'Industrial Accidents', 5, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (759, 'Specialized Sports Training 5', 5, 105);

-- Semester 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (760, 'Emergency Signaling Systems', 6, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (761, 'Emergency and Rescue Organization', 6, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (762, 'Radiation, Chemical and Biological Safety', 6, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (763, 'Rescue Training', 6, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (764, 'Urban Risk Prevention - Project', 6, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (765, 'Specialized Sports Training 6', 6, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (766, 'Special Internship', 6, 105);

-- Semester 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (767, 'Radiation, Chemical and Biological Protection', 7, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (768, 'Risk Analysis and Assessment', 7, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (769, 'Elective: Industrial and Urban Risk / Safety Management', 7, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (770, 'Emergency and Firefighting Equipment', 7, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (771, 'Protective Devices - Project', 7, 105);

-- Semester 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (772, 'Transport and Environmental Impact', 8, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (773, 'Emergency Response Tactics', 8, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (774, 'Elective: Infrastructure / Buildings in Emergencies', 8, 105);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (775, 'Marine Environmental Protection', 8, 105);



--Artificial Intelligence
-- Semester 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (776, 'Mathematics - Part 1', 1, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (777, 'Introduction to Computer Science', 1, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (778, 'Basic Programming - Part 1', 1, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (779, 'Physics for IT', 1, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (780, 'English for IT Engineers - Part 1', 1, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (781, 'Elective Course - Specialized Sports Training - Part 1 / Adapted Physical Activity', 1, 106);

-- Semester 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (782, 'Mathematics - Part 2', 2, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (783, 'Digital Systems', 2, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (784, 'Basic Programming - Part 2', 2, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (785, 'Physics for IT', 2, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (786, 'English for IT Engineers - Part 2', 2, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (787, 'Elective Course - Specialized Sports Training - Part 2 / Adapted Physical Activity', 2, 106);

-- Semester 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (788, 'Discrete Structures', 3, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (789, 'Object-Oriented Programming', 3, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (790, 'Probability Theory for Computer Science', 3, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (791, 'Computer Organization', 3, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (792, 'Practical Training – Part 2', 3, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (793, 'Elective Course - Specialized Sports Training – Part 3 / Adapted Physical Activity', 3, 106);

-- Semester 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (794, 'Foundations of Artificial Intelligence', 4, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (795, 'Databases', 4, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (796, 'Microprocessor Technology', 4, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (797, 'Digital Signal Processing', 4, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (798, 'Systems Analysis', 4, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (799, 'Elective Course – Project – Discrete Structures / OOP / Computer Org', 4, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (800, 'Elective Course - Specialized Sports Training – Part 4 / Adapted Physical Activity', 4, 106);

-- Semester 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (801, 'Introduction to Machine Learning', 5, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (802, 'Computer Graphics and VR', 5, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (803, 'Sensors, Actuators, and Controllers', 5, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (804, 'Computer Architectures', 5, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (805, 'Operating Systems', 5, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (806, 'Elective Course – Project: AI / OS / Architectures', 5, 106);

-- Semester 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (807, 'Web Programming Technologies', 6, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (808, 'Functional Programming Languages', 6, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (809, 'Selected Methods in Machine Learning', 6, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (810, 'Computer Networks', 6, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (811, 'Specialization Internship', 6, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (812, 'Elective Course – Project: ML / OS / Architectures', 6, 106);

-- Semester 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (813, 'Ethics and Legal Regulation in AI', 7, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (814, 'Robot and Robotic Systems Programming', 7, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (815, 'Parallel Algorithms and Systems', 7, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (816, 'Elective Course: Information Systems / Human-Centered Design', 7, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (817, 'Software Engineering', 7, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (818, 'Elective Course – Project: Web Tech / Functional Prog / Networks', 7, 106);

-- Semester 8 – Electives (students choose 3)
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (819, 'Bayesian Reasoning', 8, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (820, 'Image Processing and Computer Vision', 8, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (821, 'Logical Programming and Production Systems', 8, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (822, 'Intellectual Property Protection', 8, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (823, 'Commercial Law', 8, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (824, 'Natural Language Processing', 8, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (825, 'Single-Chip Microcontrollers', 8, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (826, 'Programmable Logic Design', 8, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (827, 'Object-Oriented Applications', 8, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (828, 'Blockchain Technologies and Applications', 8, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (829, 'Mobile Application Programming', 8, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (830, 'E-Commerce', 8, 106);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (831, 'Robotics Management and Planning Methods', 8, 106);



--Industrial Design 
-- Semester 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (832, 'Drawing - Part 1', 1, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (833, 'Applied Geometry and Engineering Graphics', 1, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (834, 'Mathematics', 1, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (835, 'Physics', 1, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (836, 'English - Part 1', 1, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (837, 'Elective Course – Specialized Sports Training – Part 1 / Sport and Social Adaptation – Part 1', 1, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (838, 'Practical Training – Part 1', 1, 13);

-- Semester 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (839, 'Drawing - Part 2', 2, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (840, 'Modeling', 2, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (841, 'Technical Documentation', 2, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (842, 'Materials Science and Technology of Materials', 2, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (843, 'Informatics', 2, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (844, 'Mechanical Engineering Basics', 2, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (845, 'English - Part 2', 2, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (846, 'Elective Course  – Specialized Sports Training – Part 2 / Sport and Social Adaptation – Part 2', 2, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (847, 'Practical Training – Part 2', 2, 13);

-- Semester 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (848, 'Drawing - Part 3', 3, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (849, 'Color Science', 3, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (850, 'Ergonomic Design', 3, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (851, 'Fundamentals of Computer Design', 3, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (852, 'Corporate Management', 3, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (853, 'English - Part 3', 3, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (854, 'Elective Course  – Specialized Sports Training – Part 3 / Sports Management – Part 1', 3, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (855, 'Practical Training – Part 3', 3, 13);

-- Semester 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (856, 'Computer 3D Design', 4, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (857, 'Typography and Font', 4, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (858, 'Theory of Composition', 4, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (859, 'Forming', 4, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (860, 'History of Art and Design', 4, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (861, 'Elective Course  – Specialized Sports Training – Part 4 / Sports Management – Part 2', 4, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (862, 'Practical Training – Part 4', 4, 13);

-- Semester 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (863, 'Silicate Forms Design', 5, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (864, 'Industrial Design – Part 1', 5, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (865, 'Industrial Design – Project', 5, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (866, 'Computer Animation', 5, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (867, 'Electrical Engineering and Electronics', 5, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (868, 'Graphic Design', 5, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (869, 'Elective Course  – Metal Processing / Industrial Graphics / Jewelry Design', 5, 13);

-- Semester 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (870, 'Industrial Design – Part 2', 6, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (871, 'Artistic Design', 6, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (872, 'Artistic Design – Project', 6, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (873, 'Elective Course  – Multimedia Design / 3D Digitization / Computer Modeling', 6, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (874, 'Modern Technologies in Design', 6, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (875, 'Specialization Internship', 6, 13);

-- Semester 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (876, 'Interior Design', 7, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (877, 'Interior Design – Project', 7, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (878, 'Elective Course  – Fundamentals of Marketing / Intellectual Property Law / Commercial Law', 7, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (879, 'Printing Technologies', 7, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (880, 'Urban Design', 7, 13);

-- Semester 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (881, 'Techniques and Technologies in Applied Arts', 8, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (882, 'Techniques and Technologies in Applied Arts – Project', 8, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (883, 'Marketing Communications', 8, 13);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (884, 'Elective Course 8 – Childrens Environment Design / Interactive Design', 8, 13);



--Industrial Management
-- Semester 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (885, 'Micro and Macroeconomics', 1, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (886, 'Mathematics', 1, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (887, 'Management', 1, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (888, 'Physics', 1, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (889, 'English - Part 1', 1, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (890, 'Elective Course – Specialized Sports Training – Part 1 / Sport and Social Adaptation – Part 1', 1, 31);

-- Semester 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (891, 'Materials Science and Technology of Materials', 2, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (892, 'Engineering Graphics and Technical Documentation', 2, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (893, 'Business Economics', 2, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (894, 'Electrical Engineering and Electronics', 2, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (895, 'Fundamentals of Entrepreneurship', 2, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (896, 'English - Part 2', 2, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (897, 'Elective Course – Specialized Sports Training – Part 2 / Sport and Social Adaptation – Part 2', 2, 31);

-- Semester 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (898, 'Informatics and Computer Technology', 3, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (899, 'Accounting of the Enterprise', 3, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (900, 'Marketing', 3, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (901, 'Business Communications and Public Relations', 3, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (902, 'Commercial Law', 3, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (903, 'Basics of Automation', 3, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (904, 'Elective Course – Specialized Sports Training – Part 3 / Sports Management – Part 1', 3, 31);

-- Semester 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (905, 'Strategic Management', 4, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (906, 'Fundamentals of Finance', 4, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (907, 'Human Resource Management', 4, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (908, 'Intellectual Property Protection', 4, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (909, 'Production Technologies – Part 1 (Mechanical Engineering Technologies)', 4, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (910, 'Elective Course – Specialized Sports Training – Part 4 / Sports Management – Part 2', 4, 31);

-- Semester 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (911, 'Production Technologies – Part 2 (Electrical Engineering and Electronics Technologies)', 5, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (912, 'Leadership and Team Management', 5, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (913, 'Industrial Engineering', 5, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (914, 'Corporate Finance Management', 5, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (915, 'Quality Management', 5, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (916, 'Elective Course – Presentation Skills / Time Management', 5, 31);

-- Semester 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (917, 'Production Management', 6, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (918, 'Innovation Management', 6, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (919, 'Creativity and Methods for Generating New Ideas', 6, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (920, 'Management Decision Making', 6, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (921, 'Industrial Engineering Project', 6, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (922, 'Special Practice', 6, 31);

-- Semester 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (923, 'Analysis and Diagnostics of Economic Activity', 7, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (924, 'Competitiveness of Industrial Enterprise', 7, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (925, 'Risk Management', 7, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (926, 'Business Planning and Control', 7, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (927, 'Fundamentals of Logistics', 7, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (928, 'Elective Course – Internet Tech / Renewable Energy / Maritime Transport', 7, 31);


-- Semester 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (929, 'Business Evaluation', 8, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (930, 'Elective Course – Comp. Architectures / Wind Energy / Port Tech', 8, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (931, 'Elective Course – Telecom Networks / Solar Energy / Fleet and Ports', 8, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (932, 'Management Project', 8, 31);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (933, 'Pre-diploma Practice', 8, 31);



--Engineering Ecology
-- Semester 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (934, 'Mathematics', 1, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (935, 'Chemistry', 1, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (936, 'Computer Science and Engineering', 1, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (937, 'Environmental Engineering', 1, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (938, 'English Language – Part 1', 1, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (939, 'Elective Course (Specialized Sports Training – Part 1 / Adapted Physical Activity)', 1, 107);

-- Semester 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (940, 'Engineering Mechanics', 2, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (941, 'Materials Science and Technology of Materials', 2, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (942, 'Engineering Graphics and Technical Documentation', 2, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (943, 'Machine Science', 2, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (944, 'Economics', 2, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (945, 'Natural Disasters', 2, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (946, 'Elective Course (Specialized Sports Training – Part 2 / Adapted Physical Activity)', 2, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (947, 'Internship – Part 1', 2, 107);

-- Semester 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (948, 'Physics', 3, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (949, 'Harmful Physical Environmental Factors', 3, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (950, 'Electrical Engineering and Electronics', 3, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (951, 'Statistics', 3, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (952, 'Ecology', 3, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (953, 'English Language – Part 2', 3, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (954, 'Elective Course (Specialized Sports Training – Part 3 / Adapted Physical Activity)', 3, 107);

-- Semester 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (955, 'Thermodynamics and Heat Transfer', 4, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (956, 'Hazardous Chemical Substances', 4, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (957, 'Elective Course (Meteorology and Oceanography / Physical Geography)', 4, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (958, 'Air Pollution', 4, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (959, 'Elective Course (Specialized Sports Training – Part 4 / Adapted Physical Activity)', 4, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (960, 'Internship – Part 2', 4, 107);

-- Semester 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (961, 'Occupational Safety and Work Environment Quality', 5, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (962, 'Critical Situations and Hazardous Events in Environmental Security Management', 5, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (963, 'Water Pollution', 5, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (964, 'Marine Ecology', 5, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (965, 'Industrial Accidents', 5, 107);

-- Semester 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (966, 'Fluid Treatment Technologies', 6, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (967, 'Environmental Monitoring and Expertise', 6, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (968, 'Biodiversity Conservation', 6, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (969, 'Radiation, Chemical and Biological Safety', 6, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (970, 'Urban Risk Prevention – Project', 6, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (971, 'Methods and Means for Environmental Protection in Ship Operations', 6, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (972, 'Internship – Part 3', 6, 107);

-- Semester 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (973, 'Solid Waste Treatment Technologies', 7, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (974, 'Landscape Conservation and Soil Treatment Technologies', 7, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (975, 'Environmental Management', 7, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (976, 'Risk Analysis and Assessment of Disasters, Accidents and Catastrophes', 7, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (977, 'Environmental Impact Assessment – Project', 7, 107);

-- Semester 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (978, 'Elective Course (Biotechnologies for Treatment / Microbiological Methods for Treatment)', 8, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (979, 'Transport Impact on Environment and Human Health Management', 8, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (980, 'Elective Course (Environmental Decision-Making / Ecosystem Modeling and Management)', 8, 107);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (981, 'Marine Environmental Protection in Disasters and Accidents', 8, 107);



--Intelligent Transport Systems
-- Semester 1
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (982, 'Mathematics', 1, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (983, 'Programming and Computer Usage', 1, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (984, 'Electrical Documentation', 1, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (985, 'Introduction to the Major', 1, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (986, 'Foreign Language - Part 1', 1, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (987, 'Training Practice - Part 1', 1, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (988, 'Elective Course (Specialized Sports Training / Sports and Social Adaptation)', 1, 108);

-- Semester 2
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (989, 'Technological Entrepreneurship and Innovation', 2, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (990, 'Intelligent Transport Systems', 2, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (991, 'Electronics', 2, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (992, 'Theoretical Electrical Engineering', 2, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (993, 'Foreign Language - Part 2', 2, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (994, 'Training Practice - Part 2', 2, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (995, 'Elective Course (Specialized Sports Training / Sports and Social Adaptation)', 2, 108);

-- Semester 3
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (996, 'Structure and Operation of Engines and Cars', 3, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (997, 'Electrical Measurements', 3, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (998, 'Electric Vehicles', 3, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (999, 'Electromechanical Devices', 3, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1000, 'Introduction to MATLAB', 3, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1001, 'Designing Electronic Equipment', 3, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1002, 'Elective Course (Specialized Sports Training / Sports Management)', 3, 108);

-- Semester 4
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1003, 'Fundamentals of Automatic Control', 4, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1004, 'Digital Circuit Design', 4, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1005, 'Analysis and Synthesis of Electronic Circuits', 4, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1006, 'Vehicle Control, Safety, and Comfort Systems', 4, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1007, 'Technical Safety', 4, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1008, 'Elective Course (Specialized Sports Training / Sports Management)', 4, 108);

-- Semester 5
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1009, 'Analog Circuit Design', 5, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1010, 'Testing and Verification of Electronic Devices', 5, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1011, 'Microprocessor Systems - Part 1', 5, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1012, 'Computer-Aided Electronic Design', 5, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1013, 'Power Supply Devices', 5, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1014, 'Elective Project (Analysis and Synthesis of Electronic Circuits / Designing Electronic Equipment)', 5, 108);

-- Semester 6
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1015, 'Power Conversion Technology', 6, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1016, 'Microprocessor Systems - Part 2', 6, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1017, 'Automated Vehicle Control Systems', 6, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1018, 'Hardware Programming', 6, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1019, 'Elective Course (Electric Transport / Info Systems / Automation / Micro and Nano)', 6, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1020, 'Elective Project (Computer-Aided Electronic Design / Analog Circuit Design)', 6, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1021, 'Specialized Practice', 6, 108);

-- Semester 7
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1022, 'Digital Signal Processing', 7, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1023, 'Sensor Technology', 7, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1024, 'Elective Course (Security Systems / Diagnostic Systems / Drives / Network Architectures)', 7, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1025, 'Automotive Electronics', 7, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1026, 'Microelectronics', 7, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1027, 'Elective Project (Microprocessor Systems - Part 2 / Power Conversion Technology)', 7, 108);

-- Semester 8
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1028, 'Elective Course (Automated Traffic / Displays / Converters / Electromechanical Systems)', 8, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1029, 'Elective Course (AI and Big Data / Fuel Cells / Batteries / Charging Stations)', 8, 108);
INSERT INTO predmeti (subjectid, name, semestur, specid) VALUES (1030, 'Elective Course (Cybersecurity / Standards / Hybrid Vehicles / Transport Reliability)', 8, 108);


INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (1, 'Asst.', 'Alexander', 'Markov', '10586', 11);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (2, 'Dr.', 'Velizar', 'Ivanov', '10536', 11);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (3, 'Asst.', 'Georgi', 'Vulchev', '10544', 11);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (4, 'Assoc. Prof. Dr.', 'Dimka', 'Vasileva', '10510', 11);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (5, 'Dr.', 'Konstantin', 'Mihaylov', '10535', 11);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (6, 'Assoc. Prof. Dr.', 'Krasen', 'Krystev', '10006', 11);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (7, 'Assoc. Prof. Dr.', 'Maria', 'Bakalova', '10008', 11);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (8, 'Assoc. Prof. Dr.', 'Svilen', 'Stoyanov', '10243', 11);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (9, 'Assoc. Prof. Dr.', 'Sonya', 'Alexandrova', '10039', 11);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (10, 'Prof. Dr.', 'Stoyan', 'Slavov', '10012', 11);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (11, 'Assoc. Prof. Dr.', 'Tanya', 'Avramova', '10013', 11);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (12, 'Asst.', 'Teodora', 'Peneva', '10568', 11);


INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (13, 'Assoc. Prof. Dr.', 'Georgi', 'Antonov', '10014', 6);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (14, 'Assoc. Prof. Dr.', 'Daniela', 'Spasova', '10015', 6);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (15, 'Assoc. Prof.', 'Desislava', 'Mincheva', '10016', 6);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (16, 'Assoc. Prof. Dr.', 'Nikolay', 'Atanasov', '10019', 6);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (17, 'Asst.', 'Nikolay', 'Valchev', '10594', 6);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (18, 'Asst.', 'Plamen', 'Stoyanov', '10559', 6);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (19, 'Assoc. Prof. Dr.', 'Plamen', 'Petrov', '10021', 6);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (20, 'Assoc. Prof.', 'Radosina', 'Yankova', '10592', 6);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (21, 'Assoc. Prof. Dr.', 'Sergey', 'Kirov', '10024', 6);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (22, 'Assoc. Prof. Dr.', 'Tatyana', 'Mechkarova', '10316', 6);


INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (23, 'Assoc. Prof. Dr.', 'Velichka', 'Georgieva', '10588', 8);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (24, 'Assoc. Prof. Dr.', 'Veselin', 'Mihaylov', '10044', 8);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (25, 'Assoc. Prof. Dr.', 'Daniel', 'Ivanov', '10527', 8);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (26, 'Assoc. Prof.', 'Delyan', 'Petkov', '10598', 8);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (27, 'Prof. Dr.', 'Zdravko', 'Ivanov', '10045', 8);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (28, 'Assoc. Prof. Dr.', 'Krasimir', 'Bogdanov', '10311', 8);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (29, 'Asst.', 'Nikolay', 'Ivanov', '10570', 8);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (30, 'Assoc. Prof. Dr.', 'Radostin', 'Dimitrov', '10314', 8);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (31, 'Assoc. Prof. Dr.', 'Rosen', 'Hristov', '10047', 8);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (32, 'Assoc. Prof. Dr.', 'Sergey', 'Belchev', '10048', 8);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (33, 'Assoc. Prof. Dr.', 'Stefan', 'Stefanov', '10050', 8);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (34, 'Asst.', 'Stoyan', 'Stoyanov', '10537', 8);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (35, 'Assoc. Prof. Dr.', 'Trifon', 'Uzontonev', '10051', 8);


INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (36, 'Assoc. Prof. Dr.', 'Aleksandrina', 'Bankova', '10027', 7);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (37, 'Asst. Prof. Dr.', 'Asparuh', 'Atanasov', '10513', 7);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (38, 'Assoc. Prof. Dr.', 'Diyan', 'Dimitrov', '10055', 7);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (39, 'Assoc. Prof. Dr.', 'Zoya', 'Tsoneva', '10031', 7);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (40, 'Asst. Prof. Dr.', 'Ismail', 'Mehmedov', '10530', 7);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (41, 'Lecturer', 'Krasimira', 'Koleva', '10057', 7);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (42, 'Assoc. Prof. Dr.', 'Nikolay', 'Kurtov', '10059', 7);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (43, 'Asst. Prof. Dr.', 'Nina', 'Nedeva', '10552', 7);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (44, 'Asst.', 'Plamen', 'Nikolov', '10577', 7);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (45, 'Asst. Prof. Dr.', 'Stefan', 'Tenev', '10049', 7);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (46, 'Lecturer', 'Yanka', 'Krusteva', '10060', 7);


INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (47, 'Assoc. Prof. Dr.', 'Beaneta', 'Yaneva', '10172', 31);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (48, 'Asst. Prof. Dr.', 'Vesela', 'Dicheva', '10472', 31);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (49, 'Asst. Prof. Dr.', 'Julieta', 'Mihaylova', '10584', 31);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (50, 'Assoc. Prof. Dr.', 'Krasimira', 'Dimitrova', '10250', 31);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (51, 'Asst. Prof. Dr.', 'Krasimira', 'Zagorova', '10238', 31);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (52, 'Asst. Prof. Dr.', 'Marina', 'Marinova-Stoyanova', '10252', 31);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (53, 'Asst. Prof. Dr.', 'Mihail', 'Ivanov', '10540', 31);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (54, 'Prof. Dr.', 'Svetlana', 'Lesidrenska', '10254', 31);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (55, 'Prof. Dr.', 'Svetlana', 'Dimitrakieva', '10475', 31);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (56, 'Asst. Prof. Dr.', 'Svilen', 'Simeonov', '10471', 31);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (57, 'Assoc. Prof. Dr.', 'Sibel', 'Ahmedova', '10255', 31);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (58, 'Prof. Dr.', 'Siika', 'Demirova', '10256', 31);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (59, 'Prof. Dr.', 'Tanya', 'Panayotova', '10258', 31);


INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (60, 'Assoc. Prof. Dr.', 'Albena', 'Ivanova', '10520', 82);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (61, 'Prof. Dr.', 'Dragomir', 'Dimitrov', '10298', 82);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (62, 'Prof. Dr.', 'Ivan', 'Kiryakov', '10300', 82);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (63, 'Assoc. Prof. Dr.', 'Magdalena', 'Koleva', '10560', 82);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (64, 'Assoc. Prof. Dr.', 'Miglena', 'Drumeva', '10301', 82);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (65, 'Prof. Dr.', 'Miroslav', 'Ivanov', '10494', 82);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (66, 'Assoc. Prof. Dr.', 'Nadya', 'Daskalova', '10302', 82);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (67, 'Assoc. Prof. Dr.', 'Pavlina', 'Atanasova', '10304', 82);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (68, 'Assoc. Prof. Dr.', 'Petar', 'Yankov', '10305', 82);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (69, 'Assoc. Prof. Dr.', 'Plamena', 'Pankova', '10306', 82);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (70, 'Asst.', 'Rositsa', 'Demirova', '10529', 82);


INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (71, 'Asst.', 'Ventsislav', 'Markov', '10521', 10);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (72, 'Chief Asst. Dr.', 'Galina', 'Staneva', '10029', 10);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (73, 'Chief Asst. Dr.', 'Ginka', 'Zhecheva', '10030', 10);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (74, 'Assoc. Prof. Dr.', 'Darina', 'Dobreva', '10470', 10);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (75, 'Chief Asst. Dr.', 'Iliya', 'Iliev', '10033', 10);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (76, 'Chief Asst. Dr.', 'Kremena', 'Markova', '10035', 10);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (77, 'Chief Asst. Dr.', 'Mariana', 'Murzhova', '10251', 10);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (78, 'Assoc. Prof. Dr.', 'Momchil', 'Tachev', '10037', 10);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (79, 'Prof. Dr.', 'Plamen', 'Bratanov', '10038', 10);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (80, 'Assoc. Prof. Dr.', 'Tihomir', 'Dovramadzhiev', '10040', 10);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (81, 'Assoc. Prof. Dr.', 'Tzena', 'Murzhova', '10041', 10);


INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (82, 'Assoc. Prof. Dr.', 'Anastas', 'Yangyozov', '10079', 13);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (83, 'Lecturer', 'Damqna', 'Dimitrova', '10458', 13);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (84, 'Assoc. Prof. Dr.', 'Krastin', 'Yordanov', '10065', 13);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (85, 'Chief Asst. Dr.', 'Nadezhda', 'Doseva', '10066', 13);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (86, 'Asst. Dr.', 'Nevena', 'Mileva', '10566', 13);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (87, 'Asst.', 'Nikita', 'Dobin', '10567', 13);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (88, 'Asst.', 'Nikolay', 'Kolev', '10585', 13);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (89, 'Assoc. Prof. Dr.', 'Penka', 'Zlateva', '10067', 13);


INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (90, 'Assoc. Prof. Dr.', 'Galina', 'Ilieva', '10456', 12);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (91, 'Asst.', 'Evgeni', 'Nikolaev', '10557', 12);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (92, 'Asst.', 'Ivet', 'Futchedzhieva', '10558', 12);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (93, 'Chief Asst. Dr.', 'Yordan', 'Denev', '10488', 12);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (94, 'Assoc. Prof. Dr.', 'Petar', 'Georgiev', '10072', 12);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (95, 'Chief Asst. Dr.', 'Sevdalin', 'Valchev', '10084', 12);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (96, 'Assoc. Prof. Dr.', 'Hristo', 'Pirovski', '10085', 12);


INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (97, 'Assoc. Prof. Dr.', 'Anastas', 'Krushev', '10259', 19);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (98, 'Assoc. Prof. Dr.', 'Aneta', 'Varbanova', '10476', 19);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (99, 'Assoc. Prof. Dr.', 'Bozhidar', 'Dyakov', '10263', 19);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (100, 'Lecturer', 'Bozhidar', 'Sabev', '10264', 19);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (101, 'Chief Asst. Dr.', 'Ivaylo', 'Ivanov', '10578', 19);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (102, 'Chief Asst. Dr.', 'Ivan', 'Grozev', '10272', 19);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (103, 'Chief Asst. Dr.', 'Iglika', 'Ivanova-Slavova', '10579', 19);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (104, 'Chief Asst. Dr.', 'Milen', 'Todorov', '10275', 19);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (105, 'Chief Asst. Dr.', 'Nikolay', 'Ivanov', '10551', 19);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (106, 'Asst. Dr.', 'Nikolay', 'Bedzhev', '10276', 19);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (107, 'Prof. Dr.', 'Chavdar', 'Alexandrov', '10523', 19);


INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (108, 'Assoc. Prof. Dr.', 'Aneta', 'Georgieva', '10581', 9);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (109, 'Assoc. Prof. Dr.', 'Anna', 'Simeonova', '10262', 9);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (110, 'Assoc. Prof. Dr.', 'Daniela', 'Toneva', '10291', 9);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (111, 'Asst.', 'Desislava', 'Dimitrova', '10574', 9);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (112, 'Chief Asst. Dr.', 'Elena', 'Valkova', '10517', 9);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (113, 'Chief Asst. Dr.', 'Stefan', 'Kolev', '10483', 9);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (114, 'Assoc. Prof. Dr.', 'Stoyan', 'Vergiev', '10495', 9);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (115, 'Chief Asst. Dr.', 'Tatyana', 'Zhekova', '10069', 9);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (116, 'Asst.', 'Todorka', 'Stankova', '10518', 9);


INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (117, 'Assoc. Prof. Dr.', 'Valentin', 'Gyurov', '10094', 14);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (118, 'Assoc. Prof. Dr.', 'Vladimir', 'Chikov', '10095', 14);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (119, 'Asst.', 'Galin', 'Segov', '10573', 14);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (120, 'Asst.', 'Georgi', 'Milev', '10508', 14);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (121, 'Assoc. Prof. Dr.', 'Ginka', 'Ivanova', '10466', 14);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (122, 'Asst.', 'Milen', 'Duganov', '10562', 14);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (123, 'Chief Asst. Dr.', 'Nikola', 'Makedonski', '10100', 14);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (124, 'Assoc. Prof. Dr.', 'Plamen', 'Parushev', '10101', 14);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (125, 'Chief Asst. Dr.', 'Hristiyan', 'Panchev', '10484', 14);


INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (126, 'Prepod.', 'Anton', 'Filipov', '10104', 42);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (127, 'Asst.', 'Dimitar', 'Georgiev', '10532', 42);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (128, 'Asst.', 'Ivan', 'Tonev', '10587', 42);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (129, 'Assoc. Prof. Dr.', 'Yoncho', 'Kamenov', '10105', 42);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (130, 'Assoc. Prof. Dr.', 'Milena', 'Ivanova', '10112', 42);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (131, 'Assoc. Prof. Dr.', 'Nikolay', 'Nikolaev', '10113', 42);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (132, 'Chief Asst. Dr.', 'Rositsa', 'Dimitrova', '10114', 42);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (133, 'Assoc. Prof. Dr.', 'Yulian', 'Rangelov', '10115', 42);


INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (134, 'Prof. Dr.', 'Bohos Rupen', 'Aprahamyan', '10118', 15);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (135, 'Chief Asst. Dr.', 'Georgi Dimitrov', 'Zhelev', '10515', 15);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (136, 'Assoc. Prof. Dr.', 'Mike Jurgen', 'Shtreblau', '10120', 15);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (137, 'Asst.', 'Marin Todorov', 'Marinov', '10546', 15);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (138, 'Assoc. Prof. Dr.', 'Maria Ivanova', 'Marinova', '10121', 15);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (139, 'Chief Asst. Dr.', 'Pavel Ivanov', 'Andreev', '10550', 15);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (140, 'Assoc. Prof. Dr.', 'Tatyana Marinova', 'Dimova', '10123', 15);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (141, 'Chief Asst. Dr.', 'Yanita Stoyanova', 'Slavova', '10125', 15);


INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (142, 'Chief Assoc. Dr.', 'Zlatan', 'Ganev', '10130', 16);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (143, 'Assoc. Prof. Dr.', 'Ivaylo', 'Nedelchev', '10131', 16);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (144, 'Assoc. Prof. Dr.', 'Ilonka', 'Lilyanova', '10132', 16);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (145, 'Assoc. Prof. Dr.', 'Marin', 'Marinov', '10133', 16);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (146, 'Chief Assoc. Dr.', 'Miroslava', 'Doneva', '10134', 16);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (147, 'Asst. Dr.', 'Nadezhda', 'Tsvetkova', '10569', 16);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (148, 'Asst.', 'Rosen', 'Dimitrov', '10575', 16);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (149, 'Assoc. Prof. Dr.', 'Hristo', 'Karaivanov', '10137', 16);


INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (150, 'Chief Asst. Dr.', 'Anna', 'Nikolova', '10326', 45);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (151, 'Assoc. Prof. Dr.', 'Vsevolod', 'Ivanov', '10327', 45);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (152, 'Asst. Dr.', 'Gergana', 'Tsvetkova', '10329', 45);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (153, 'Assoc. Prof. Dr.', 'Diana', 'Nedelcheva', '10330', 45);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (154, 'Asst. Dr.', 'Dragomir', 'Dragnev', '10580', 45);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (155, 'Asst.', 'Mariela', 'Mihova', '10582', 45);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (156, 'Chief Asst. Dr.', 'Meline', 'Aprahamyan', '10335', 45);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (157, 'Chief Asst. Dr.', 'Nedka', 'Pulova', '10336', 45);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (158, 'Assoc. Prof. Dr.', 'Peycho', 'Popov', '10288', 45);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (159, 'Chief Asst. Dr.', 'Rumen', 'Marinov', '10338', 45);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (160, 'Assoc. Prof. Dr.', 'Svetlana', 'Dimova-Burlanenko', '10597', 45);


INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (161, 'Assoc. Prof. Dr.', 'Daniela', 'Petrova', '10174', 17);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (162, 'Assoc. Prof. Dr.', 'Ivaylo', 'Tsanov', '10461', 17);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (163, 'Assoc. Prof. Dr.', 'Irina', 'Todorova', '10177', 17);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (164, 'Chief Asst. Dr.', 'Krasimira', 'Georgieva', '10178', 17);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (165, 'Assoc. Prof. Dr.', 'Lachezar', 'Avramov', '10180', 17);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (166, 'Assoc. Prof. Dr.', 'Maria', 'Zheleva', '10181', 17);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (167, 'Chief Asst. Dr.', 'Plamena', 'Markova', '10460', 17);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (168, 'Asst.', 'Sirma', 'Kazakova', '10590', 17);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (169, 'Assoc. Prof. Dr.', 'Toshko', 'Petrov', '10184', 17);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (170, 'Asst.', 'Hristiyana', 'Todorova', '10554', 17);


INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (171, 'Chief Asst. Dr.', 'Boris', 'Nikolov', '10139', 4);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (172, 'Assoc. Prof. Dr.', 'Borislav', 'Naidenov', '10140', 4);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (173, 'Prof. Dr.', 'Valentina', 'Markova', '10141', 4);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (174, 'Asst. Dr.', 'Georgi', 'Bebrov', '10497', 4);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (175, 'Chief Asst. Dr.', 'Georgi', 'Chervenkov', '10144', 4);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (176, 'Asst.', 'Zornitsa', 'Petrova', '10539', 4);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (177, 'Assoc. Prof. Dr.', 'Lyubomir', 'Kamburov', '10147', 4);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (178, 'Chief Asst. Dr.', 'Martin', 'Ivanov', '10149', 4);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (179, 'Asst.', 'Nikolay', 'Dimitrov', '10549', 4);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (180, 'Assoc. Prof. Dr.', 'Nikolay', 'Kostov', '10150', 4);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (181, 'Chief Asst. Dr.', 'Plamen', 'Stoyanov', '10152', 4);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (182, 'Prof. Dr.', 'Rozalina', 'Dimova', '10153', 4);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (183, 'Assoc. Prof. Dr.', 'Stela', 'Kostadinova', '10154', 4);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (184, 'Assoc. Prof. Dr.', 'Todorka', 'Georgieva', '10155', 4);


INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (185, 'Assoc. Prof. Dr.', 'Angel', 'Marinov', '10156', 2);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (186, 'Asst.', 'Angelina', 'Dimitrova', '10589', 2);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (187, 'Lecturer', 'Antim', 'Yordanov', '10157', 2);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (188, 'Asst.', 'Boyan', 'Karamilev', '10553', 2);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (189, 'Prof. Dr.', 'Ventsislav', 'Valchev', '10159', 2);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (190, 'Chief Asst. Dr.', 'Desislava', 'Mihaylova', '10464', 2);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (191, 'Assoc. Prof. Dr.', 'Ekaterina', 'Dimitrova', '10163', 2);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (192, 'Assoc. Prof. Dr.', 'Emiliyan', 'Bekov', '10164', 2);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (193, 'Assoc. Prof. Dr.', 'Ivan', 'Buliev', '10165', 2);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (194, 'Asst.', 'Kaloyan', 'Solenkov', '10538', 2);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (195, 'Chief Asst. Dr.', 'Svetlozar', 'Zahariev', '10242', 2);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (196, 'Assoc. Prof. Dr.', 'Toncho', 'Papanchev', '10171', 2);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (197, 'Assoc. Prof. Dr.', 'Firgan', 'Feradov', '10500', 2);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (198, 'Asst.', 'Yulia', 'Garipova', '10506', 2);


INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (199, 'Assoc. Prof. Dr.', 'Vesko', 'Uzunov', '10187', 1);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (200, 'Chief Asst. Dr.', 'Dian', 'Dzhibarov', '10189', 1);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (201, 'Lecturer', 'Elena', 'Vasileva', '10190', 1);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (202, 'Assoc. Prof. Dr.', 'Zhivko', 'Zhekov', '10310', 1);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (203, 'Chief Asst. Dr.', 'Ivan', 'Grigorov', '10509', 1);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (204, 'Asst. Dr.', 'Iliyan', 'Iliev', '10565', 1);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (205, 'Assoc. Prof. Dr.', 'Mariela', 'Alexandrova', '10312', 1);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (206, 'Assoc. Prof. Dr.', 'Mariana', 'Todorova', '10192', 1);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (207, 'Assoc. Prof. Dr.', 'Nasko', 'Atanasov', '10194', 1);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (208, 'Prof. Dr.', 'Nikola', 'Nikolov', '10313', 1);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (209, 'Chief Asst. Dr.', 'Reneta', 'Parvanova', '10498', 1);


INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (210, 'Assoc. Prof. Dr.', 'Aidan', 'Huk', '10486', 3);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (211, 'Asst.', 'Ayshe', 'Shaban', '10593', 3);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (212, 'Asst.', 'Venelin', 'Maleshkov', '10555', 3);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (213, 'Prof. Dr.', 'Veneta', 'Alexieva', '10204', 3);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (214, 'Assoc. Prof. Dr.', 'Ventsislav', 'Nikolov', '10355', 3);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (215, 'Asst.', 'Viktor', 'Mashkov', '10547', 3);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (216, 'Assoc. Prof. Dr.', 'Gergana', 'Spasova', '10451', 3);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (217, 'Chief Asst. Dr.', 'Ginka', 'Marinova', '10210', 3);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (218, 'Asst.', 'Desislava', 'Angelova-Zheynova', '10571', 3);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (219, 'Assoc. Prof. Dr.', 'Zheyno', 'Zheynov', '10214', 3);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (220, 'Assoc. Prof. Dr.', 'Ivaylo', 'Penev', '10215', 3);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (221, 'Chief Asst. Dr.', 'Iliyan', 'Boychev', '10452', 3);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (222, 'Chief Asst. Dr.', 'Lychezar', 'Georgiev', '10216', 3);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (223, 'Asst.', 'Marieta', 'Huk', '10548', 3);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (224, 'Chief Asst. Dr.', 'Milen', 'Angelov', '10219', 3);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (225, 'Prof. Dr.', 'Milena', 'Mileva-Karova', '10220', 3);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (226, 'Asst.', 'Petko', 'Genchev', '10505', 3);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (227, 'Chief Asst. Dr.', 'Prolet', 'Deneva', '10516', 3);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (228, 'Prof. Dr.', 'Todor', 'Ganchev', '10170', 3);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (229, 'Asst.', 'Toni', 'Tomov', '10591', 3);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (230, 'Prof. Dr.', 'Hristo', 'Valchanov', '10233', 3);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (231, 'Asst.', 'Hristo', 'Hristov', '10576', 3);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (232, 'Assoc. Prof. Dr.', 'Yulka', 'Petkova', '10234', 3);


INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (233, 'Lecturer', 'Antoaneta', 'Ivanova-Dimitrova', '10201', 5);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (234, 'Lecturer', 'Velislav', 'Kolesnichenko', '10514', 5);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (235, 'Assoc. Prof. Dr.', 'Violeta', 'Bozhikova', '10205', 5);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (236, 'Asst.', 'Genoveva', 'Kostova', '10596', 5);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (237, 'Assoc. Prof. Dr.', 'Geo', 'Kunev', '10208', 5);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (238, 'Asst.', 'Ginka', 'Antonova', '10572', 5);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (239, 'Asst.', 'Daniela', 'Petrova', '10526', 5);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (240, 'Chief Asst. Dr.', 'Dimitrichka', 'Nikolaeva', '10454', 5);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (241, 'Assoc. Prof. Dr.', 'Diyan', 'Dinev', '10487', 5);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (242, 'Chief Asst. Dr.', 'Donika', 'Stoyanova', '10522', 5);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (243, 'Chief Asst. Dr.', 'Evgenia', 'Rakitina-Kureshi', '10541', 5);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (244, 'Asst.', 'Ivo', 'Rakitin', '10542', 5);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (245, 'Assoc. Prof. Dr.', 'Maryana', 'Stoeva', '10217', 5);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (246, 'Chief Asst. Dr.', 'Maya', 'Todorova', '10218', 5);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (247, 'Asst.', 'Mikola', 'Mindov', '10595', 5);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (248, 'Asst. Dr.', 'Miroslav', 'Markov', '10524', 5);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (249, 'Assoc. Prof. Dr.', 'Neli', 'Arabadzhieva-Kalcheva', '10354', 5);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (250, 'Assoc. Prof. Dr.', 'Rosen', 'Radkov', '10226', 5);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (251, 'Chief Asst. Dr.', 'Svetlana', 'Paskaleva', '10241', 5);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (252, 'Lecturer', 'Stefka', 'Popova', '10229', 5);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (253, 'Assoc. Prof. Dr.', 'Hristo', 'Nenov', '10232', 5);


INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (254, 'Lecturer', 'Denislav', 'Kotsev', '10531', 18);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (255, 'Senior Lecturer', 'Ivan', 'Ivanov', '10087', 18);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (256, 'Senior Lecturer', 'Nikolay', 'Yanchev', '10091', 18);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (257, 'Lecturer', 'Stefan', 'Stoyanov', '10556', 18);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (258, 'Assoc. Prof. Dr.', 'Yavor', 'Nestorov', '10092', 18);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (259, 'Chief Asst. Dr.', 'Yanka', 'Georgieva', '10093', 18);


INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (260, 'Senior Lecturer', 'Anna', 'Mitkova', '10261', 53);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (261, 'Senior Lecturer', 'Boryana', 'Gencheva', '10265', 53);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (262, 'Senior Lecturer', 'Violeta', 'Karastateva', '10318', 53);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (263, 'Assoc. Prof. Dr.', 'Elena', 'Kovacheva', '10563', 53);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (264, 'Senior Lecturer', 'Esin', 'Halid', '10271', 53);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (265, 'Lecturer', 'Marieta', 'Radeva', '10583', 53);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (266, 'Senior Lecturer', 'Milena', 'Zlateva', '10321', 53);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (267, 'Senior Lecturer', 'Nadezhda', 'Tsoneva', '10322', 53);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (268, 'Senior Lecturer', 'Nadezhda', 'Hristova', '10323', 53);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (269, 'Senior Lecturer', 'Svetla', 'Sabeva', '10324', 53);
INSERT INTO lecturers (lecturerid, titla, firstname, lastname, lecturernom, katedraid) VALUES (270, 'Assoc. Prof. Dr.', 'Sevdalina', 'Georgieva', '10564', 53);





CREATE SEQUENCE ocenki_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

DECLARE
    -- Cursor for all students in specid 66
    CURSOR c_students IS
        SELECT studentid, semesturcount
        FROM students
        WHERE specid = 66;

    -- Cursor for all subjects in specid 66
    CURSOR c_subjects IS
        SELECT subjectid, semestur
        FROM predmeti
        WHERE specid = 66;

    v_grade NUMBER;
    v_lecturer_id NUMBER;
BEGIN
    FOR v_student IN c_students LOOP
        FOR v_subject IN c_subjects LOOP
            -- Only assign grade if subject's semester <= student's current semester
            IF v_subject.semestur <= v_student.semesturcount THEN
                -- Generate mostly above average grades
                IF DBMS_RANDOM.VALUE < 0.8 THEN
                    v_grade := TRUNC(DBMS_RANDOM.VALUE(5,7)); -- 5 or 6
                ELSE
                    v_grade := TRUNC(DBMS_RANDOM.VALUE(3,5)); -- 3 or 4
                END IF;

                -- Random lecturerid between 1 and N (replace N with max lecturerid)
                v_lecturer_id := TRUNC(DBMS_RANDOM.VALUE(1, 10)); 

                -- Insert into OCENKI table
                INSERT INTO ocenki (gradeid, studentid, subjectid, lecturerid, grade, "Date")
                VALUES (
                    ocenki_seq.NEXTVAL,
                    v_student.studentid,
                    v_subject.subjectid,
                    v_lecturer_id,
                    v_grade,
                    SYSDATE
                );
            END IF;
        END LOOP;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Grades assigned for all students in specid 66.');
END;



-- Create a sequence for exam IDs
CREATE SEQUENCE izpiti_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

DECLARE
    -- Cursor for all groups in specid 66
    CURSOR c_groups IS
        SELECT groupid, kurs
        FROM grupi
        WHERE specid = 66;

    -- Cursor for all subjects with exams
    CURSOR c_subjects IS
        SELECT subjectid, semestur
        FROM predmeti
        WHERE specid = 66
        AND name IN (
            'Mathematics - Part 1',
            'Mathematics - Part 2',
            'Electronics',
            'Theoretical Electrical Engineering',
            'Electrical Measurements',
            'Technical Mechanics',
            'Electromechanical Devices',
            'Control Theory - Part 1',
            'Data and Signal Processing in Automation',
            'Digital Circuitry',
            'Control Theory - Part 2',
            'Technical Means for Automation',
            'Embedded Systems',
            'Programmable Controllers',
            'System Identification',
            'Electronic Actuators in Automation',
            'Automated Electric Drives',
            'Control of Technological Processes',
            'Control of Electromechanical Systems',
            'System Modeling and Optimization',
            'Elective - Industrial Information Systems or Control of Electric Drives',
            'Design of Automation Systems',
            'Elective - CAD Systems or Automation of Renewable Energy Sources',
            'Elective - Building Automation or Adaptive and Robust Control',
            'Intelligent Control Systems'
        );

    v_group c_groups%ROWTYPE;
    v_subject c_subjects%ROWTYPE;
    v_exam_date DATE;
    v_exam_type VARCHAR2(20);
BEGIN
    FOR v_group IN c_groups LOOP
        FOR v_subject IN c_subjects LOOP
            -- Only assign if subject semester <= group's current semester
            IF v_subject.semestur <= v_group.kurs THEN
                -- Determine exam date based on semester
                IF MOD(v_subject.semestur,2) = 1 THEN
                    -- Odd semester: 15–31 Jan main, 1–7 Feb retake
                    IF DBMS_RANDOM.VALUE < 0.85 THEN
                        v_exam_date := TRUNC(DATE '2025-01-15' + DBMS_RANDOM.VALUE(0,16)); -- main
                        v_exam_type := 'first_take';
                    ELSE
                        v_exam_date := TRUNC(DATE '2025-02-01' + DBMS_RANDOM.VALUE(0,6)); -- retake
                        v_exam_type := 'retake';
                    END IF;
                ELSE
                    -- Even semester: 1–21 June main, 22–28 June retake
                    IF DBMS_RANDOM.VALUE < 0.85 THEN
                        v_exam_date := TRUNC(DATE '2025-06-01' + DBMS_RANDOM.VALUE(0,20)); -- main
                        v_exam_type := 'first_take';
                    ELSE
                        v_exam_date := TRUNC(DATE '2025-06-22' + DBMS_RANDOM.VALUE(0,6)); -- retake
                        v_exam_type := 'retake';
                    END IF;
                END IF;

                -- Insert into izpiti
                INSERT INTO izpiti (izpitid, subjectid, groupid, "Date", type)
                VALUES (izpiti_seq.NEXTVAL, v_subject.subjectid, v_group.groupid, v_exam_date, v_exam_type);
            END IF;
        END LOOP;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Exams assigned for all groups in specid 66.');
END;
/




CREATE SEQUENCE programi_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

ALTER TABLE programi
MODIFY hour VARCHAR2(20);





CREATE SEQUENCE users_seq
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE SEQUENCE students_seq
    START WITH 201
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

ALTER TABLE predmeti ADD has_lecture NUMBER(1) DEFAULT 1;
ALTER TABLE predmeti ADD has_exercise NUMBER(1) DEFAULT 1;


-- 1st Semester
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Mathematics - Part 1';
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Programming and Computer Use';
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Electrical Documentation';
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Economics';
UPDATE predmeti SET has_lecture = 0, has_exercise = 1 WHERE name = 'Foreign Language - Part 1';
UPDATE predmeti SET has_lecture = 0, has_exercise = 1 WHERE name = 'Practical Training - Part 1';
UPDATE predmeti SET has_lecture = 0, has_exercise = 1 WHERE name LIKE 'Specialized Sports%';

-- 2nd Semester
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Mathematics - Part 2';
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Physics';
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Electronics';
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Theoretical Electrical Engineering';
UPDATE predmeti SET has_lecture = 0, has_exercise = 1 WHERE name = 'Foreign Language - Part 2';
UPDATE predmeti SET has_lecture = 0, has_exercise = 1 WHERE name = 'Practical Training - Part 2';
UPDATE predmeti SET has_lecture = 0, has_exercise = 1 WHERE name LIKE 'Specialized Sports%';

-- 3rd Semester
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Electrical Engineering Materials';
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Electrical Measurements';
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Technical Mechanics';
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Electromechanical Devices';
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Introduction to MATLAB';
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Sensors in Automation and Robotics';
UPDATE predmeti SET has_lecture = 0, has_exercise = 1 WHERE name LIKE 'Specialized Sports%';

-- 4th Semester
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Control Theory - Part 1';
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Data and Signal Processing in Automation';
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Digital Circuitry';
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Logic Control Systems';
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Technical Safety';
UPDATE predmeti SET has_lecture = 0, has_exercise = 1 WHERE name LIKE 'Specialized Sports%';

-- 5th Semester
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Control Theory - Part 2';
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Digital Control Systems';
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Technical Means for Automation';
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Embedded Systems';
UPDATE predmeti SET has_lecture = 0, has_exercise = 1 WHERE name LIKE 'Elective - Project%';

-- 6th Semester
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Programmable Controllers';
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'System Identification';
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Electronic Actuators in Automation';
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Automated Electric Drives';
UPDATE predmeti SET has_lecture = 0, has_exercise = 1 WHERE name LIKE 'Elective Project%';
UPDATE predmeti SET has_lecture = 0, has_exercise = 0 WHERE name LIKE 'Specialized Internship%';

-- 7th Semester
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Control of Technological Processes';
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Control of Electromechanical Systems';
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'System Modeling and Optimization';
UPDATE predmeti SET has_lecture = 0, has_exercise = 1 WHERE name LIKE 'Elective - Industrial Information Systems%';
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Industrial Communication Systems';
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Design of Automation Systems';

-- 8th Semester
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Design of Automation Systems';
UPDATE predmeti SET has_lecture = 0, has_exercise = 1 WHERE name LIKE 'Elective - CAD Systems%';
UPDATE predmeti SET has_lecture = 0, has_exercise = 1 WHERE name LIKE 'Elective - Building Automation%';
UPDATE predmeti SET has_lecture = 1, has_exercise = 1 WHERE name = 'Intelligent Control Systems';
UPDATE predmeti SET has_lecture = 0, has_exercise = 1 WHERE name LIKE 'Comprehensive Project%';

COMMIT;


-- Delete all existing schedule entries for this specialty (specid = 66)
DELETE FROM programi
WHERE groupid IN (
    SELECT groupid FROM grupi WHERE specid = 66
);

COMMIT;


DECLARE
    -- Cursor for all groups in specialty 66
    CURSOR c_groups IS
        SELECT groupid, kurs, specid, name, education_type_id
        FROM grupi
        WHERE specid = 66
        ORDER BY kurs, education_type_id;

    -- Days and hours arrays
    v_days SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST('Monday','Tuesday','Wednesday','Thursday','Friday');
    v_hours SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST(
        '07:30-09:00','09:15-10:45','11:00-12:30','12:45-14:15','14:30-16:00','16:15-17:45','18:00-19:30'
    );

    -- associative array to track lectures already inserted per (course + type + subject)
    TYPE t_course_seen IS TABLE OF NUMBER INDEX BY VARCHAR2(100);
    course_seen t_course_seen;

    v_key VARCHAR2(100);
    v_subjectid NUMBER;
    v_groupid NUMBER;
    v_course NUMBER;
    v_edu_type NUMBER;
    v_day VARCHAR2(20);
    v_hour VARCHAR2(20);
    v_lecturerid NUMBER;

BEGIN
    FOR g IN c_groups LOOP
        v_groupid := g.groupid;
        v_course  := g.kurs;
        v_edu_type := g.education_type_id;

        -- Loop through all subjects in specialty 66
        FOR s IN (SELECT subjectid, name, semestur FROM predmeti WHERE specid = 66 ORDER BY semestur, subjectid) LOOP
            v_subjectid := s.subjectid;

            -- Key for lecture: course + education_type + subject
            v_key := v_course || '-' || v_edu_type || '-' || v_subjectid;

            -- RANDOM day/time
            v_day := v_days(TRUNC(DBMS_RANDOM.value(1, v_days.COUNT+1)));
            v_hour := v_hours(TRUNC(DBMS_RANDOM.value(1, v_hours.COUNT+1)));
            v_lecturerid := TRUNC(DBMS_RANDOM.value(1, 11)); -- assuming lecturer IDs 1..10

            -- INSERT LECTURE (only once per course+subject)
            IF NOT course_seen.EXISTS(v_key) THEN
                INSERT INTO programi(programid, groupid, subjectid, day, hour, lecturerid, type)
                VALUES (programi_seq.NEXTVAL, v_groupid, v_subjectid, v_day, v_hour, v_lecturerid, 'Lecture');

                course_seen(v_key) := 1;
            END IF;

            -- INSERT EXERCISE for each group individually
            v_day := v_days(TRUNC(DBMS_RANDOM.value(1, v_days.COUNT+1)));
            v_hour := v_hours(TRUNC(DBMS_RANDOM.value(1, v_hours.COUNT+1)));
            v_lecturerid := TRUNC(DBMS_RANDOM.value(1, 11));

            INSERT INTO programi(programid, groupid, subjectid, day, hour, lecturerid, type)
            VALUES (programi_seq.NEXTVAL, v_groupid, v_subjectid, v_day, v_hour, v_lecturerid, 'Exercise');

        END LOOP;
    END LOOP;

    COMMIT;
END;
/


SELECT 
    p.programid, 
    p.subjectid, 
    s.name AS subject_name, 
    p.lecturerid, 
    l.firstname || ' ' || l.lastname AS lecturer_name, 
    p.type AS type_col
FROM programi p
JOIN predmeti s ON p.subjectid = s.subjectid
JOIN lecturers l ON p.lecturerid = l.lecturerid
WHERE p.groupid = 2563
ORDER BY p.type, s.name;
