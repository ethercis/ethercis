CREATE OR REPLACE FUNCTION delete_subject(VARCHAR, VARCHAR)
  RETURNS VOID AS
  $delete$
  DECLARE
    id_code ALIAS FOR $1;
    issuer_code ALIAS FOR $2;
    party_id UUID;
  BEGIN
-- get the party identified

    IF (SELECT EXISTS(SELECT *
                      FROM ehr.identifier
                      WHERE id_value = id_code AND issuer = issuer_code))
    THEN
      SELECT party
      FROM ehr.identifier
      WHERE id_value = id_code AND issuer = issuer_code
      INTO party_id;
      DELETE FROM ehr.identifier
      WHERE id_value = id_code AND issuer = issuer_code;
      DELETE FROM ehr.party_identified
      WHERE id = party_id;
    ELSE
      RAISE NOTICE 'Not found %:%', id_code, issuer_code;
    END IF;
  END;
  $delete$

LANGUAGE plpgsql;