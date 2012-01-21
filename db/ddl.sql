DROP TABLE IF EXISTS queues CASCADE;
CREATE TABLE queues(
  id            serial UNIQUE PRIMARY KEY,
  name          text   UNIQUE
);
INSERT INTO queues(name) VALUES ('default');

DROP TABLE IF EXISTS messages CASCADE;
CREATE TABLE messages (
  id              bigserial UNIQUE PRIMARY KEY,
  queue_id        integer   REFERENCES queues(id),
  payload         text      NOT NULL,
  ready_at        timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  reserved_at     timestamp,
  reserved_by     text, -- application_name
  reserved_ip     inet  -- inet_client_addr()
);

DROP TABLE IF EXISTS messages_history CASCADE;
CREATE TABLE messages_history (
  id              bigint    UNIQUE PRIMARY KEY,
  queue_id        integer   REFERENCES queues(id),
  payload         text      NOT NULL,
  ready_at        timestamp NOT NULL,
  reserved_at     timestamp NOT NULL,
  reserved_by     text      NOT NULL,
  reserved_ip     inet      NOT NULL,
  finalized_at    timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  finalized_note  text
);
-- CREATE INDEX messages_history_ready_at_idx     ON messages_history(ready_at);
-- CREATE INDEX messages_history_reserved_at_idx  ON messages_history(reserved_at);
-- CREATE INDEX messages_history_reserved_ip_idx  ON messages_history(reserved_ip);
-- CREATE INDEX messages_history_finalized_at_idx ON messages_history(finalized_at);

CREATE SEQUENCE application_id_seq
  INCREMENT BY 1
  MINVALUE 1
  NO MAXVALUE
  NO CYCLE
  OWNED BY messages.reserved_by
  ;
