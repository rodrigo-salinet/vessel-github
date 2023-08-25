CREATE TABLE IF NOT EXISTS dataflow_batch_export (
    batch_export_id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    batch_id int(10) unsigned NOT NULL DEFAULT '0',
    batch_data longtext,
    status tinyint(3) unsigned NOT NULL DEFAULT '0',
    PRIMARY KEY (batch_export_id),
    KEY FK_DATAFLOW_BATCH_EXPORT_BATCH (batch_id),
    CONSTRAINT FK_DATAFLOW_BATCH_EXPORT_BATCH FOREIGN KEY (batch_id) REFERENCES dataflow_batch (batch_id) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4174 DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS dataflow_batch_import (
    batch_import_id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    batch_id int(10) unsigned NOT NULL DEFAULT '0',
    batch_data longtext,
    status tinyint(3) unsigned NOT NULL DEFAULT '0',
    PRIMARY KEY (batch_import_id),
    KEY FK_DATAFLOW_BATCH_IMPORT_BATCH (batch_id),
    CONSTRAINT FK_DATAFLOW_BATCH_IMPORT_BATCH FOREIGN KEY (batch_id) REFERENCES dataflow_batch (batch_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS report_event (
    event_id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    logged_at datetime NOT NULL,
    event_type_id smallint(6) unsigned NOT NULL DEFAULT '0',
    object_id int(10) unsigned NOT NULL DEFAULT '0',
    subject_id int(10) unsigned NOT NULL DEFAULT '0',
    subtype tinyint(3) unsigned NOT NULL DEFAULT '0',
    store_id smallint(5) unsigned NOT NULL,
    PRIMARY KEY (event_id),
    KEY IDX_EVENT_TYPE (event_type_id),
    KEY IDX_SUBJECT (subject_id),
    KEY IDX_OBJECT (object_id),
    KEY IDX_SUBTYPE (subtype),
    KEY FK_REPORT_EVENT_STORE (store_id),
    CONSTRAINT FK_REPORT_EVENT_STORE FOREIGN KEY (store_id) REFERENCES core_store (store_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_REPORT_EVENT_TYPE FOREIGN KEY (event_type_id) REFERENCES report_event_types (event_type_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4944993 DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS log_url (
    url_id bigint(20) unsigned NOT NULL DEFAULT '0',
    visitor_id bigint(20) unsigned DEFAULT NULL,
    visit_time datetime NOT NULL,
    PRIMARY KEY (url_id),
    KEY IDX_VISITOR (visitor_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='URL visiting history';
CREATE TABLE IF NOT EXISTS log_url_info (
    url_id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    url varchar(255) NOT NULL DEFAULT '',
    referer varchar(255) DEFAULT NULL,
    PRIMARY KEY (url_id)
) ENGINE=InnoDB AUTO_INCREMENT=25748539 DEFAULT CHARSET=utf8 COMMENT='Detale information about url visit';
CREATE TABLE IF NOT EXISTS log_customer (
    log_id int(10) unsigned NOT NULL AUTO_INCREMENT,
    visitor_id bigint(20) unsigned DEFAULT NULL,
    customer_id int(11) NOT NULL DEFAULT '0',
    login_at datetime NOT NULL,
    logout_at datetime DEFAULT NULL,
    store_id smallint(5) unsigned NOT NULL,
    PRIMARY KEY (log_id),
    KEY IDX_VISITOR (visitor_id)
) ENGINE=InnoDB AUTO_INCREMENT=179351 DEFAULT CHARSET=utf8 COMMENT='Customers log information';
CREATE TABLE IF NOT EXISTS log_quote (
    quote_id int(10) unsigned NOT NULL DEFAULT '0',
    visitor_id bigint(20) unsigned DEFAULT NULL,
    created_at datetime NOT NULL,
    deleted_at datetime DEFAULT NULL,
    PRIMARY KEY (quote_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Quote log data';
CREATE TABLE IF NOT EXISTS log_summary (
    summary_id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    store_id smallint(5) unsigned NOT NULL,
    type_id smallint(5) unsigned DEFAULT NULL,
    visitor_count int(11) NOT NULL DEFAULT '0',
    customer_count int(11) NOT NULL DEFAULT '0',
    add_date datetime NOT NULL,
    PRIMARY KEY (summary_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Summary log information';
CREATE TABLE IF NOT EXISTS log_summary_type (
    type_id smallint(5) unsigned NOT NULL AUTO_INCREMENT,
    type_code varchar(64) NOT NULL DEFAULT '',
    period smallint(5) unsigned NOT NULL DEFAULT '0',
    period_type enum('MINUTE','HOUR','DAY','WEEK','MONTH') NOT NULL DEFAULT 'MINUTE',
    PRIMARY KEY (type_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Type of summary information';
CREATE TABLE IF NOT EXISTS log_url (
    url_id bigint(20) unsigned NOT NULL DEFAULT '0',
    visitor_id bigint(20) unsigned DEFAULT NULL,
    visit_time datetime NOT NULL,
    PRIMARY KEY (url_id),
    KEY IDX_VISITOR (visitor_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='URL visiting history';
CREATE TABLE IF NOT EXISTS log_url_info (
    url_id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    url varchar(255) NOT NULL DEFAULT '',
    referer varchar(255) DEFAULT NULL,
    PRIMARY KEY (url_id)
) ENGINE=InnoDB AUTO_INCREMENT=25748539 DEFAULT CHARSET=utf8 COMMENT='Detale information about url visit';
CREATE TABLE IF NOT EXISTS log_visitor (
    visitor_id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    session_id char(64) NOT NULL DEFAULT '',
    first_visit_at datetime DEFAULT NULL,
    last_visit_at datetime NOT NULL,
    last_url_id bigint(20) unsigned NOT NULL DEFAULT '0',
    store_id smallint(5) unsigned NOT NULL,
    PRIMARY KEY (visitor_id)
) ENGINE=InnoDB AUTO_INCREMENT=7761836 DEFAULT CHARSET=utf8 COMMENT='System visitors log';
CREATE TABLE IF NOT EXISTS log_visitor_info (
    visitor_id bigint(20) unsigned NOT NULL DEFAULT '0',
    http_referer varchar(255) DEFAULT NULL,
    http_user_agent varchar(255) DEFAULT NULL,
    http_accept_charset varchar(255) DEFAULT NULL,
    http_accept_language varchar(255) DEFAULT NULL,
    server_addr bigint(20) DEFAULT NULL,
    remote_addr bigint(20) DEFAULT NULL,
    PRIMARY KEY (visitor_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Additional information by visitor';
CREATE TABLE IF NOT EXISTS log_visitor_online (
    visitor_id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    visitor_type char(1) NOT NULL,
    remote_addr bigint(20) NOT NULL,
    first_visit_at datetime DEFAULT NULL,
    last_visit_at datetime DEFAULT NULL,
    customer_id int(10) unsigned DEFAULT NULL,
    last_url varchar(255) DEFAULT NULL,
    PRIMARY KEY (visitor_id),
    KEY IDX_VISITOR_TYPE (visitor_type),
    KEY IDX_VISIT_TIME (first_visit_at,last_visit_at),
    KEY IDX_CUSTOMER (customer_id)
) ENGINE=InnoDB AUTO_INCREMENT=7433337 DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS report_event (
    event_id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    logged_at datetime NOT NULL,
    event_type_id smallint(6) unsigned NOT NULL DEFAULT '0',
    object_id int(10) unsigned NOT NULL DEFAULT '0',
    subject_id int(10) unsigned NOT NULL DEFAULT '0',
    subtype tinyint(3) unsigned NOT NULL DEFAULT '0',
    store_id smallint(5) unsigned NOT NULL,
    PRIMARY KEY (event_id),
    KEY IDX_EVENT_TYPE (event_type_id),
    KEY IDX_SUBJECT (subject_id),
    KEY IDX_OBJECT (object_id),
    KEY IDX_SUBTYPE (subtype),
    KEY FK_REPORT_EVENT_STORE (store_id),
    CONSTRAINT FK_REPORT_EVENT_STORE FOREIGN KEY (store_id) REFERENCES core_store (store_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_REPORT_EVENT_TYPE FOREIGN KEY (event_type_id) REFERENCES report_event_types (event_type_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4944993 DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS index_event (
    event_id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
    type varchar(64) NOT NULL,
    entity varchar(64) NOT NULL,
    entity_pk bigint(20) DEFAULT NULL,
    created_at datetime NOT NULL,
    old_data mediumtext,
    new_data mediumtext,
    PRIMARY KEY (event_id),
    UNIQUE KEY IDX_UNIQUE_EVENT (type,entity,entity_pk)
) ENGINE=InnoDB AUTO_INCREMENT=12935 DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS core_cache (
    id varchar(255) NOT NULL,
    data mediumblob,
    create_time int(11) DEFAULT NULL,
    update_time int(11) DEFAULT NULL,
    expire_time int(11) DEFAULT NULL,
    PRIMARY KEY (id),
    KEY IDX_EXPIRE_TIME (expire_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS core_cache_tag (
    tag varchar(100) NOT NULL DEFAULT '',
    cache_id varchar(200) NOT NULL DEFAULT '',
    PRIMARY KEY (tag,cache_id),
    KEY IDX_CACHE_ID (cache_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS core_session (
    session_id varchar(255) NOT NULL DEFAULT '',
    website_id smallint(5) unsigned DEFAULT NULL,
    session_expires int(10) unsigned NOT NULL DEFAULT '0',
    session_data mediumblob NOT NULL,
    PRIMARY KEY (session_id),
    KEY FK_SESSION_WEBSITE (website_id),
    CONSTRAINT FK_SESSION_WEBSITE FOREIGN KEY (website_id) REFERENCES core_website (website_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Session data store';
CREATE TABLE IF NOT EXISTS core_cache_tag (
    tag varchar(100) NOT NULL DEFAULT '',
    cache_id varchar(200) NOT NULL DEFAULT '',
    PRIMARY KEY (tag,cache_id),
    KEY IDX_CACHE_ID (cache_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
