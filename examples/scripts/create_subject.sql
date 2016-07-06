CREATE OR REPLACE FUNCTION create_subject(VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR ) RETURNS VOID AS
$create$
DECLARE
  subject_name ALIAS FOR $1;
  id_code ALIAS FOR $2;
  issuer_code ALIAS FOR $3;
  assigner_code ALIAS FOR $4;
  typename ALIAS FOR $5;
  party_id UUID;
BEGIN
-- create a party_identified with subject name and get the corresponding uuid
  IF (SELECT NOT EXISTS(SELECT *
                        FROM ehr.identifier
                        WHERE identifier.id_value = id_code AND identifier.issuer = issuer_code))
  THEN
    INSERT INTO ehr.party_identified (name) VALUES (subject_name)
    RETURNING id
      INTO party_id;
    INSERT INTO ehr.identifier (id_value, issuer, assigner, type_name, party)
    VALUES (id_code, issuer_code, assigner_code, typename, party_id);
  ELSE
    RAISE NOTICE 'Subject already exists for %, %, %, %, %', subject_name, id_code, issuer_code, assigner_code, typename;
  END IF;
END;
$create$

LANGUAGE plpgsql;
