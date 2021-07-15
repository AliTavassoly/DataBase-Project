/*
on insert to advertisment_related_skills insert into new_add_notif
on insert to HW_Delivary and course.is_public = false , check if user is a participants.
*/

DROP TRIGGER QueraEcoPlus.new_adv_notif;
CREATE TRIGGER QueraEcoPlus.new_adv_notif AFTER INSERT ON QueraEcoPlus.ADV_RELATIVE_SKILLS
FOR EACH ROW BEGIN
    DECLARE i INT;
    DECLARE n INT;
    DECLARE user_id INT;
    DECLARE not_id INT;
    SET i = 0;  
    SELECT count(CV_WORK_INFO_INTRESTS.USER_ID) FROM QueraEcoPlus.CV_WORK_INFO_INTRESTS 
        WHERE CV_WORK_INFO_INTRESTS.SKILL_NAME = NEW.SKILL_NAME INTO n;
    WHILE i < n DO
        SELECT max(USER_ID) FROM QueraEcoPlus.CV_WORK_INFO_INTRESTS WHERE CV_WORK_INFO_INTRESTS.SKILL_NAME = NEW.SKILL_NAME LIMIT i,1 INTO user_id;
        SELECT max(AUTO_INCREMENT) FROM INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_NAME = 'NOTIFICATION' INTO not_id;
        INSERT INTO NOTIFICATION(CREATION_DATE, BODY) VALUES(CURRENT_TIME, 'new job offer');
        INSERT INTO USER_NOTIFICATION VALUES(not_id, user_id);
        INSERT INTO NEW_ADD_NOTIF VALUES(not_id, NEW.COMPANY_REGISTRATION_ID, NEW.ADD_ID);
        SET i = i + 1;
    END WHILE;
end;

SELECT * FROM INFORMATION_SCHEMA.TRIGGERS;