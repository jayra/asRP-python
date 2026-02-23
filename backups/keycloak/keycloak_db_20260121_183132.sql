--
-- PostgreSQL database dump
--

\restrict s4FANF5L4ujZ0HIN8k1UCkmAye4uuXuVMqcOq4ncDwSIskCpuSWSBPwTLJVYVXB

-- Dumped from database version 16.11 (Debian 16.11-1.pgdg13+1)
-- Dumped by pg_dump version 16.11 (Debian 16.11-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin_event_entity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.admin_event_entity (
    id character varying(36) NOT NULL,
    admin_event_time bigint,
    realm_id character varying(255),
    operation_type character varying(255),
    auth_realm_id character varying(255),
    auth_client_id character varying(255),
    auth_user_id character varying(255),
    ip_address character varying(255),
    resource_path character varying(2550),
    representation text,
    error character varying(255),
    resource_type character varying(64)
);


ALTER TABLE public.admin_event_entity OWNER TO keycloak;

--
-- Name: associated_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.associated_policy (
    policy_id character varying(36) NOT NULL,
    associated_policy_id character varying(36) NOT NULL
);


ALTER TABLE public.associated_policy OWNER TO keycloak;

--
-- Name: authentication_execution; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authentication_execution (
    id character varying(36) NOT NULL,
    alias character varying(255),
    authenticator character varying(36),
    realm_id character varying(36),
    flow_id character varying(36),
    requirement integer,
    priority integer,
    authenticator_flow boolean DEFAULT false NOT NULL,
    auth_flow_id character varying(36),
    auth_config character varying(36)
);


ALTER TABLE public.authentication_execution OWNER TO keycloak;

--
-- Name: authentication_flow; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authentication_flow (
    id character varying(36) NOT NULL,
    alias character varying(255),
    description character varying(255),
    realm_id character varying(36),
    provider_id character varying(36) DEFAULT 'basic-flow'::character varying NOT NULL,
    top_level boolean DEFAULT false NOT NULL,
    built_in boolean DEFAULT false NOT NULL
);


ALTER TABLE public.authentication_flow OWNER TO keycloak;

--
-- Name: authenticator_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authenticator_config (
    id character varying(36) NOT NULL,
    alias character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.authenticator_config OWNER TO keycloak;

--
-- Name: authenticator_config_entry; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authenticator_config_entry (
    authenticator_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.authenticator_config_entry OWNER TO keycloak;

--
-- Name: broker_link; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.broker_link (
    identity_provider character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL,
    broker_user_id character varying(255),
    broker_username character varying(255),
    token text,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.broker_link OWNER TO keycloak;

--
-- Name: client; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client (
    id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    full_scope_allowed boolean DEFAULT false NOT NULL,
    client_id character varying(255),
    not_before integer,
    public_client boolean DEFAULT false NOT NULL,
    secret character varying(255),
    base_url character varying(255),
    bearer_only boolean DEFAULT false NOT NULL,
    management_url character varying(255),
    surrogate_auth_required boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    protocol character varying(255),
    node_rereg_timeout integer DEFAULT 0,
    frontchannel_logout boolean DEFAULT false NOT NULL,
    consent_required boolean DEFAULT false NOT NULL,
    name character varying(255),
    service_accounts_enabled boolean DEFAULT false NOT NULL,
    client_authenticator_type character varying(255),
    root_url character varying(255),
    description character varying(255),
    registration_token character varying(255),
    standard_flow_enabled boolean DEFAULT true NOT NULL,
    implicit_flow_enabled boolean DEFAULT false NOT NULL,
    direct_access_grants_enabled boolean DEFAULT false NOT NULL,
    always_display_in_console boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client OWNER TO keycloak;

--
-- Name: client_attributes; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_attributes (
    client_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.client_attributes OWNER TO keycloak;

--
-- Name: client_auth_flow_bindings; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_auth_flow_bindings (
    client_id character varying(36) NOT NULL,
    flow_id character varying(36),
    binding_name character varying(255) NOT NULL
);


ALTER TABLE public.client_auth_flow_bindings OWNER TO keycloak;

--
-- Name: client_initial_access; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_initial_access (
    id character varying(36) NOT NULL,
    realm_id character varying(36) NOT NULL,
    "timestamp" integer,
    expiration integer,
    count integer,
    remaining_count integer
);


ALTER TABLE public.client_initial_access OWNER TO keycloak;

--
-- Name: client_node_registrations; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_node_registrations (
    client_id character varying(36) NOT NULL,
    value integer,
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_node_registrations OWNER TO keycloak;

--
-- Name: client_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope (
    id character varying(36) NOT NULL,
    name character varying(255),
    realm_id character varying(36),
    description character varying(255),
    protocol character varying(255)
);


ALTER TABLE public.client_scope OWNER TO keycloak;

--
-- Name: client_scope_attributes; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope_attributes (
    scope_id character varying(36) NOT NULL,
    value character varying(2048),
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_scope_attributes OWNER TO keycloak;

--
-- Name: client_scope_client; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope_client (
    client_id character varying(255) NOT NULL,
    scope_id character varying(255) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client_scope_client OWNER TO keycloak;

--
-- Name: client_scope_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope_role_mapping (
    scope_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.client_scope_role_mapping OWNER TO keycloak;

--
-- Name: client_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session (
    id character varying(36) NOT NULL,
    client_id character varying(36),
    redirect_uri character varying(255),
    state character varying(255),
    "timestamp" integer,
    session_id character varying(36),
    auth_method character varying(255),
    realm_id character varying(255),
    auth_user_id character varying(36),
    current_action character varying(36)
);


ALTER TABLE public.client_session OWNER TO keycloak;

--
-- Name: client_session_auth_status; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session_auth_status (
    authenticator character varying(36) NOT NULL,
    status integer,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_auth_status OWNER TO keycloak;

--
-- Name: client_session_note; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session_note (
    name character varying(255) NOT NULL,
    value character varying(255),
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_note OWNER TO keycloak;

--
-- Name: client_session_prot_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session_prot_mapper (
    protocol_mapper_id character varying(36) NOT NULL,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_prot_mapper OWNER TO keycloak;

--
-- Name: client_session_role; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session_role (
    role_id character varying(255) NOT NULL,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_role OWNER TO keycloak;

--
-- Name: client_user_session_note; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_user_session_note (
    name character varying(255) NOT NULL,
    value character varying(2048),
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_user_session_note OWNER TO keycloak;

--
-- Name: component; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.component (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_id character varying(36),
    provider_id character varying(36),
    provider_type character varying(255),
    realm_id character varying(36),
    sub_type character varying(255)
);


ALTER TABLE public.component OWNER TO keycloak;

--
-- Name: component_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.component_config (
    id character varying(36) NOT NULL,
    component_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.component_config OWNER TO keycloak;

--
-- Name: composite_role; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.composite_role (
    composite character varying(36) NOT NULL,
    child_role character varying(36) NOT NULL
);


ALTER TABLE public.composite_role OWNER TO keycloak;

--
-- Name: credential; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    user_id character varying(36),
    created_date bigint,
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.credential OWNER TO keycloak;

--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO keycloak;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO keycloak;

--
-- Name: default_client_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.default_client_scope (
    realm_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.default_client_scope OWNER TO keycloak;

--
-- Name: event_entity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.event_entity (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    details_json character varying(2550),
    error character varying(255),
    ip_address character varying(255),
    realm_id character varying(255),
    session_id character varying(255),
    event_time bigint,
    type character varying(255),
    user_id character varying(255),
    details_json_long_value text
);


ALTER TABLE public.event_entity OWNER TO keycloak;

--
-- Name: fed_user_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_attribute (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    value character varying(2024),
    long_value_hash bytea,
    long_value_hash_lower_case bytea,
    long_value text
);


ALTER TABLE public.fed_user_attribute OWNER TO keycloak;

--
-- Name: fed_user_consent; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.fed_user_consent OWNER TO keycloak;

--
-- Name: fed_user_consent_cl_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_consent_cl_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.fed_user_consent_cl_scope OWNER TO keycloak;

--
-- Name: fed_user_credential; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    created_date bigint,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.fed_user_credential OWNER TO keycloak;

--
-- Name: fed_user_group_membership; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_group_membership OWNER TO keycloak;

--
-- Name: fed_user_required_action; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_required_action (
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_required_action OWNER TO keycloak;

--
-- Name: fed_user_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_role_mapping (
    role_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_role_mapping OWNER TO keycloak;

--
-- Name: federated_identity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.federated_identity (
    identity_provider character varying(255) NOT NULL,
    realm_id character varying(36),
    federated_user_id character varying(255),
    federated_username character varying(255),
    token text,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_identity OWNER TO keycloak;

--
-- Name: federated_user; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.federated_user (
    id character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_user OWNER TO keycloak;

--
-- Name: group_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.group_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_attribute OWNER TO keycloak;

--
-- Name: group_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.group_role_mapping (
    role_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_role_mapping OWNER TO keycloak;

--
-- Name: identity_provider; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.identity_provider (
    internal_id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    provider_alias character varying(255),
    provider_id character varying(255),
    store_token boolean DEFAULT false NOT NULL,
    authenticate_by_default boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    add_token_role boolean DEFAULT true NOT NULL,
    trust_email boolean DEFAULT false NOT NULL,
    first_broker_login_flow_id character varying(36),
    post_broker_login_flow_id character varying(36),
    provider_display_name character varying(255),
    link_only boolean DEFAULT false NOT NULL
);


ALTER TABLE public.identity_provider OWNER TO keycloak;

--
-- Name: identity_provider_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.identity_provider_config (
    identity_provider_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.identity_provider_config OWNER TO keycloak;

--
-- Name: identity_provider_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.identity_provider_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    idp_alias character varying(255) NOT NULL,
    idp_mapper_name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.identity_provider_mapper OWNER TO keycloak;

--
-- Name: idp_mapper_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.idp_mapper_config (
    idp_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.idp_mapper_config OWNER TO keycloak;

--
-- Name: keycloak_group; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.keycloak_group (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_group character varying(36) NOT NULL,
    realm_id character varying(36)
);


ALTER TABLE public.keycloak_group OWNER TO keycloak;

--
-- Name: keycloak_role; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.keycloak_role (
    id character varying(36) NOT NULL,
    client_realm_constraint character varying(255),
    client_role boolean DEFAULT false NOT NULL,
    description character varying(255),
    name character varying(255),
    realm_id character varying(255),
    client character varying(36),
    realm character varying(36)
);


ALTER TABLE public.keycloak_role OWNER TO keycloak;

--
-- Name: migration_model; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.migration_model (
    id character varying(36) NOT NULL,
    version character varying(36),
    update_time bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.migration_model OWNER TO keycloak;

--
-- Name: offline_client_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.offline_client_session (
    user_session_id character varying(36) NOT NULL,
    client_id character varying(255) NOT NULL,
    offline_flag character varying(4) NOT NULL,
    "timestamp" integer,
    data text,
    client_storage_provider character varying(36) DEFAULT 'local'::character varying NOT NULL,
    external_client_id character varying(255) DEFAULT 'local'::character varying NOT NULL,
    version integer DEFAULT 0
);


ALTER TABLE public.offline_client_session OWNER TO keycloak;

--
-- Name: offline_user_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.offline_user_session (
    user_session_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    created_on integer NOT NULL,
    offline_flag character varying(4) NOT NULL,
    data text,
    last_session_refresh integer DEFAULT 0 NOT NULL,
    broker_session_id character varying(1024),
    version integer DEFAULT 0
);


ALTER TABLE public.offline_user_session OWNER TO keycloak;

--
-- Name: org; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.org (
    id character varying(255) NOT NULL,
    enabled boolean NOT NULL,
    realm_id character varying(255) NOT NULL,
    group_id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000)
);


ALTER TABLE public.org OWNER TO keycloak;

--
-- Name: org_domain; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.org_domain (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    verified boolean NOT NULL,
    org_id character varying(255) NOT NULL
);


ALTER TABLE public.org_domain OWNER TO keycloak;

--
-- Name: policy_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.policy_config (
    policy_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.policy_config OWNER TO keycloak;

--
-- Name: protocol_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.protocol_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    protocol character varying(255) NOT NULL,
    protocol_mapper_name character varying(255) NOT NULL,
    client_id character varying(36),
    client_scope_id character varying(36)
);


ALTER TABLE public.protocol_mapper OWNER TO keycloak;

--
-- Name: protocol_mapper_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.protocol_mapper_config (
    protocol_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.protocol_mapper_config OWNER TO keycloak;

--
-- Name: realm; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm (
    id character varying(36) NOT NULL,
    access_code_lifespan integer,
    user_action_lifespan integer,
    access_token_lifespan integer,
    account_theme character varying(255),
    admin_theme character varying(255),
    email_theme character varying(255),
    enabled boolean DEFAULT false NOT NULL,
    events_enabled boolean DEFAULT false NOT NULL,
    events_expiration bigint,
    login_theme character varying(255),
    name character varying(255),
    not_before integer,
    password_policy character varying(2550),
    registration_allowed boolean DEFAULT false NOT NULL,
    remember_me boolean DEFAULT false NOT NULL,
    reset_password_allowed boolean DEFAULT false NOT NULL,
    social boolean DEFAULT false NOT NULL,
    ssl_required character varying(255),
    sso_idle_timeout integer,
    sso_max_lifespan integer,
    update_profile_on_soc_login boolean DEFAULT false NOT NULL,
    verify_email boolean DEFAULT false NOT NULL,
    master_admin_client character varying(36),
    login_lifespan integer,
    internationalization_enabled boolean DEFAULT false NOT NULL,
    default_locale character varying(255),
    reg_email_as_username boolean DEFAULT false NOT NULL,
    admin_events_enabled boolean DEFAULT false NOT NULL,
    admin_events_details_enabled boolean DEFAULT false NOT NULL,
    edit_username_allowed boolean DEFAULT false NOT NULL,
    otp_policy_counter integer DEFAULT 0,
    otp_policy_window integer DEFAULT 1,
    otp_policy_period integer DEFAULT 30,
    otp_policy_digits integer DEFAULT 6,
    otp_policy_alg character varying(36) DEFAULT 'HmacSHA1'::character varying,
    otp_policy_type character varying(36) DEFAULT 'totp'::character varying,
    browser_flow character varying(36),
    registration_flow character varying(36),
    direct_grant_flow character varying(36),
    reset_credentials_flow character varying(36),
    client_auth_flow character varying(36),
    offline_session_idle_timeout integer DEFAULT 0,
    revoke_refresh_token boolean DEFAULT false NOT NULL,
    access_token_life_implicit integer DEFAULT 0,
    login_with_email_allowed boolean DEFAULT true NOT NULL,
    duplicate_emails_allowed boolean DEFAULT false NOT NULL,
    docker_auth_flow character varying(36),
    refresh_token_max_reuse integer DEFAULT 0,
    allow_user_managed_access boolean DEFAULT false NOT NULL,
    sso_max_lifespan_remember_me integer DEFAULT 0 NOT NULL,
    sso_idle_timeout_remember_me integer DEFAULT 0 NOT NULL,
    default_role character varying(255)
);


ALTER TABLE public.realm OWNER TO keycloak;

--
-- Name: realm_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_attribute (
    name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    value text
);


ALTER TABLE public.realm_attribute OWNER TO keycloak;

--
-- Name: realm_default_groups; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_default_groups (
    realm_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_default_groups OWNER TO keycloak;

--
-- Name: realm_enabled_event_types; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_enabled_event_types (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_enabled_event_types OWNER TO keycloak;

--
-- Name: realm_events_listeners; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_events_listeners (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_events_listeners OWNER TO keycloak;

--
-- Name: realm_localizations; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_localizations (
    realm_id character varying(255) NOT NULL,
    locale character varying(255) NOT NULL,
    texts text NOT NULL
);


ALTER TABLE public.realm_localizations OWNER TO keycloak;

--
-- Name: realm_required_credential; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_required_credential (
    type character varying(255) NOT NULL,
    form_label character varying(255),
    input boolean DEFAULT false NOT NULL,
    secret boolean DEFAULT false NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_required_credential OWNER TO keycloak;

--
-- Name: realm_smtp_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_smtp_config (
    realm_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.realm_smtp_config OWNER TO keycloak;

--
-- Name: realm_supported_locales; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_supported_locales (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_supported_locales OWNER TO keycloak;

--
-- Name: redirect_uris; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.redirect_uris (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.redirect_uris OWNER TO keycloak;

--
-- Name: required_action_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.required_action_config (
    required_action_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.required_action_config OWNER TO keycloak;

--
-- Name: required_action_provider; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.required_action_provider (
    id character varying(36) NOT NULL,
    alias character varying(255),
    name character varying(255),
    realm_id character varying(36),
    enabled boolean DEFAULT false NOT NULL,
    default_action boolean DEFAULT false NOT NULL,
    provider_id character varying(255),
    priority integer
);


ALTER TABLE public.required_action_provider OWNER TO keycloak;

--
-- Name: resource_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    resource_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_attribute OWNER TO keycloak;

--
-- Name: resource_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_policy (
    resource_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_policy OWNER TO keycloak;

--
-- Name: resource_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_scope (
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_scope OWNER TO keycloak;

--
-- Name: resource_server; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server (
    id character varying(36) NOT NULL,
    allow_rs_remote_mgmt boolean DEFAULT false NOT NULL,
    policy_enforce_mode smallint NOT NULL,
    decision_strategy smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.resource_server OWNER TO keycloak;

--
-- Name: resource_server_perm_ticket; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_perm_ticket (
    id character varying(36) NOT NULL,
    owner character varying(255) NOT NULL,
    requester character varying(255) NOT NULL,
    created_timestamp bigint NOT NULL,
    granted_timestamp bigint,
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36),
    resource_server_id character varying(36) NOT NULL,
    policy_id character varying(36)
);


ALTER TABLE public.resource_server_perm_ticket OWNER TO keycloak;

--
-- Name: resource_server_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_policy (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    type character varying(255) NOT NULL,
    decision_strategy smallint,
    logic smallint,
    resource_server_id character varying(36) NOT NULL,
    owner character varying(255)
);


ALTER TABLE public.resource_server_policy OWNER TO keycloak;

--
-- Name: resource_server_resource; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_resource (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255),
    icon_uri character varying(255),
    owner character varying(255) NOT NULL,
    resource_server_id character varying(36) NOT NULL,
    owner_managed_access boolean DEFAULT false NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_resource OWNER TO keycloak;

--
-- Name: resource_server_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_scope (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    icon_uri character varying(255),
    resource_server_id character varying(36) NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_scope OWNER TO keycloak;

--
-- Name: resource_uris; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_uris (
    resource_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.resource_uris OWNER TO keycloak;

--
-- Name: role_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.role_attribute (
    id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255)
);


ALTER TABLE public.role_attribute OWNER TO keycloak;

--
-- Name: scope_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.scope_mapping (
    client_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_mapping OWNER TO keycloak;

--
-- Name: scope_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.scope_policy (
    scope_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_policy OWNER TO keycloak;

--
-- Name: user_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_attribute (
    name character varying(255) NOT NULL,
    value character varying(255),
    user_id character varying(36) NOT NULL,
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    long_value_hash bytea,
    long_value_hash_lower_case bytea,
    long_value text
);


ALTER TABLE public.user_attribute OWNER TO keycloak;

--
-- Name: user_consent; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(36) NOT NULL,
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.user_consent OWNER TO keycloak;

--
-- Name: user_consent_client_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_consent_client_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.user_consent_client_scope OWNER TO keycloak;

--
-- Name: user_entity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_entity (
    id character varying(36) NOT NULL,
    email character varying(255),
    email_constraint character varying(255),
    email_verified boolean DEFAULT false NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    federation_link character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    realm_id character varying(255),
    username character varying(255),
    created_timestamp bigint,
    service_account_client_link character varying(255),
    not_before integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_entity OWNER TO keycloak;

--
-- Name: user_federation_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_config (
    user_federation_provider_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_config OWNER TO keycloak;

--
-- Name: user_federation_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    federation_provider_id character varying(36) NOT NULL,
    federation_mapper_type character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.user_federation_mapper OWNER TO keycloak;

--
-- Name: user_federation_mapper_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_mapper_config (
    user_federation_mapper_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_mapper_config OWNER TO keycloak;

--
-- Name: user_federation_provider; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_provider (
    id character varying(36) NOT NULL,
    changed_sync_period integer,
    display_name character varying(255),
    full_sync_period integer,
    last_sync integer,
    priority integer,
    provider_name character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.user_federation_provider OWNER TO keycloak;

--
-- Name: user_group_membership; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_group_membership OWNER TO keycloak;

--
-- Name: user_required_action; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_required_action (
    user_id character varying(36) NOT NULL,
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL
);


ALTER TABLE public.user_required_action OWNER TO keycloak;

--
-- Name: user_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_role_mapping (
    role_id character varying(255) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_role_mapping OWNER TO keycloak;

--
-- Name: user_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_session (
    id character varying(36) NOT NULL,
    auth_method character varying(255),
    ip_address character varying(255),
    last_session_refresh integer,
    login_username character varying(255),
    realm_id character varying(255),
    remember_me boolean DEFAULT false NOT NULL,
    started integer,
    user_id character varying(255),
    user_session_state integer,
    broker_session_id character varying(255),
    broker_user_id character varying(255)
);


ALTER TABLE public.user_session OWNER TO keycloak;

--
-- Name: user_session_note; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_session_note (
    user_session character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(2048)
);


ALTER TABLE public.user_session_note OWNER TO keycloak;

--
-- Name: username_login_failure; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.username_login_failure (
    realm_id character varying(36) NOT NULL,
    username character varying(255) NOT NULL,
    failed_login_not_before integer,
    last_failure bigint,
    last_ip_failure character varying(255),
    num_failures integer
);


ALTER TABLE public.username_login_failure OWNER TO keycloak;

--
-- Name: web_origins; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.web_origins (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.web_origins OWNER TO keycloak;

--
-- Data for Name: admin_event_entity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.admin_event_entity (id, admin_event_time, realm_id, operation_type, auth_realm_id, auth_client_id, auth_user_id, ip_address, resource_path, representation, error, resource_type) FROM stdin;
\.


--
-- Data for Name: associated_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.associated_policy (policy_id, associated_policy_id) FROM stdin;
\.


--
-- Data for Name: authentication_execution; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authentication_execution (id, alias, authenticator, realm_id, flow_id, requirement, priority, authenticator_flow, auth_flow_id, auth_config) FROM stdin;
4c234d04-d81d-4c29-90ec-279596d69c97	\N	auth-cookie	e42af33c-a898-43d7-a74a-41752eb401e5	10b4264e-2d4d-4ecf-98f8-a1848f488ad3	2	10	f	\N	\N
b90284f9-a123-4d8a-94a6-69d2876a5b7b	\N	auth-spnego	e42af33c-a898-43d7-a74a-41752eb401e5	10b4264e-2d4d-4ecf-98f8-a1848f488ad3	3	20	f	\N	\N
198357de-1479-49bb-9b2a-cbf97290908c	\N	identity-provider-redirector	e42af33c-a898-43d7-a74a-41752eb401e5	10b4264e-2d4d-4ecf-98f8-a1848f488ad3	2	25	f	\N	\N
39541ea3-fa0c-453a-8369-38d005a1eb8e	\N	\N	e42af33c-a898-43d7-a74a-41752eb401e5	10b4264e-2d4d-4ecf-98f8-a1848f488ad3	2	30	t	7b9e66ce-fdf8-4383-b917-123c6a95811d	\N
55e15d3a-079c-49fd-9158-5ea33afb931f	\N	auth-username-password-form	e42af33c-a898-43d7-a74a-41752eb401e5	7b9e66ce-fdf8-4383-b917-123c6a95811d	0	10	f	\N	\N
085585a0-3c0d-42bc-b013-c62f6fb9c0e2	\N	\N	e42af33c-a898-43d7-a74a-41752eb401e5	7b9e66ce-fdf8-4383-b917-123c6a95811d	1	20	t	a77dd05b-bc84-4285-92fe-d8156227871f	\N
b338d360-96f6-451f-9cb7-4402d3e28514	\N	conditional-user-configured	e42af33c-a898-43d7-a74a-41752eb401e5	a77dd05b-bc84-4285-92fe-d8156227871f	0	10	f	\N	\N
44199de0-6c5a-4f04-a025-843e9aacb416	\N	auth-otp-form	e42af33c-a898-43d7-a74a-41752eb401e5	a77dd05b-bc84-4285-92fe-d8156227871f	0	20	f	\N	\N
52bdb7f2-4f86-4f73-959a-3c41207efd21	\N	direct-grant-validate-username	e42af33c-a898-43d7-a74a-41752eb401e5	91d89739-c488-4681-b818-5919a01b3f41	0	10	f	\N	\N
f253a870-fb81-4a8c-bddd-6b8683fc3fff	\N	direct-grant-validate-password	e42af33c-a898-43d7-a74a-41752eb401e5	91d89739-c488-4681-b818-5919a01b3f41	0	20	f	\N	\N
7e24f2b7-8a56-40ae-9204-e507d9ec303b	\N	\N	e42af33c-a898-43d7-a74a-41752eb401e5	91d89739-c488-4681-b818-5919a01b3f41	1	30	t	261dc4f5-0b1c-4fef-aae8-8be4e2619895	\N
bc270fe3-e20e-4479-9625-48056062e6c9	\N	conditional-user-configured	e42af33c-a898-43d7-a74a-41752eb401e5	261dc4f5-0b1c-4fef-aae8-8be4e2619895	0	10	f	\N	\N
cac748f5-fe56-4977-83e9-03accd35f5bc	\N	direct-grant-validate-otp	e42af33c-a898-43d7-a74a-41752eb401e5	261dc4f5-0b1c-4fef-aae8-8be4e2619895	0	20	f	\N	\N
387ae4f0-42f3-4794-a12b-42fbc79aefb8	\N	registration-page-form	e42af33c-a898-43d7-a74a-41752eb401e5	ea34474c-d836-45a2-bb69-3c24aa5aecc3	0	10	t	fd90afea-eea5-40ad-b126-32d0ee89ebc8	\N
4f865449-ea43-4b79-b2d3-6b41a5413d20	\N	registration-user-creation	e42af33c-a898-43d7-a74a-41752eb401e5	fd90afea-eea5-40ad-b126-32d0ee89ebc8	0	20	f	\N	\N
2282d859-1a22-44a8-8b7d-963d442add64	\N	registration-password-action	e42af33c-a898-43d7-a74a-41752eb401e5	fd90afea-eea5-40ad-b126-32d0ee89ebc8	0	50	f	\N	\N
4de1a50c-3f48-4e3d-98a0-d085e9e759d8	\N	registration-recaptcha-action	e42af33c-a898-43d7-a74a-41752eb401e5	fd90afea-eea5-40ad-b126-32d0ee89ebc8	3	60	f	\N	\N
33ff4aff-f1af-4b3e-9452-d1c3f5b731a1	\N	registration-terms-and-conditions	e42af33c-a898-43d7-a74a-41752eb401e5	fd90afea-eea5-40ad-b126-32d0ee89ebc8	3	70	f	\N	\N
396d5149-3683-43ec-a20e-9f9ca61cc324	\N	reset-credentials-choose-user	e42af33c-a898-43d7-a74a-41752eb401e5	a3ad244c-0a14-4d76-98ba-9aad17da3ec3	0	10	f	\N	\N
5db467e4-637c-4846-891a-99d57ef04688	\N	reset-credential-email	e42af33c-a898-43d7-a74a-41752eb401e5	a3ad244c-0a14-4d76-98ba-9aad17da3ec3	0	20	f	\N	\N
dd6d15c5-6da2-464a-9e64-a316476471e6	\N	reset-password	e42af33c-a898-43d7-a74a-41752eb401e5	a3ad244c-0a14-4d76-98ba-9aad17da3ec3	0	30	f	\N	\N
499b1de5-d99e-4697-b498-050a6a5733ac	\N	\N	e42af33c-a898-43d7-a74a-41752eb401e5	a3ad244c-0a14-4d76-98ba-9aad17da3ec3	1	40	t	b0306f3d-3f46-41fd-99a1-1897709330ce	\N
06896b8d-e322-4f42-bfdc-f6008ffb42a7	\N	conditional-user-configured	e42af33c-a898-43d7-a74a-41752eb401e5	b0306f3d-3f46-41fd-99a1-1897709330ce	0	10	f	\N	\N
0f2ce3c2-3541-4d25-8654-73d051e279de	\N	reset-otp	e42af33c-a898-43d7-a74a-41752eb401e5	b0306f3d-3f46-41fd-99a1-1897709330ce	0	20	f	\N	\N
210224aa-8402-41e7-ae3e-288b6e1dbf94	\N	client-secret	e42af33c-a898-43d7-a74a-41752eb401e5	c120b351-6345-4afd-b962-b4cb48be12f4	2	10	f	\N	\N
b80d1136-fbe5-40ff-a348-daf0726fb86f	\N	client-jwt	e42af33c-a898-43d7-a74a-41752eb401e5	c120b351-6345-4afd-b962-b4cb48be12f4	2	20	f	\N	\N
6e7c1587-769e-49a3-80e8-9369072fb3aa	\N	client-secret-jwt	e42af33c-a898-43d7-a74a-41752eb401e5	c120b351-6345-4afd-b962-b4cb48be12f4	2	30	f	\N	\N
8b0c3dfc-b6b6-408f-bea4-0ff7af1c3669	\N	client-x509	e42af33c-a898-43d7-a74a-41752eb401e5	c120b351-6345-4afd-b962-b4cb48be12f4	2	40	f	\N	\N
e1a0d0ba-18ab-4647-89f9-296769d960cb	\N	idp-review-profile	e42af33c-a898-43d7-a74a-41752eb401e5	a4f88fd1-e081-449e-a104-4056b5bfa4f8	0	10	f	\N	a06e95fe-417c-4617-8b3a-432737ebcad7
1ceee50b-0b8a-4924-8c61-474be2cafa5f	\N	\N	e42af33c-a898-43d7-a74a-41752eb401e5	a4f88fd1-e081-449e-a104-4056b5bfa4f8	0	20	t	31f4d510-9d46-488a-a7a3-9aef696607a8	\N
f9d8733a-bee3-4a89-8d22-cc4be1b1b67d	\N	idp-create-user-if-unique	e42af33c-a898-43d7-a74a-41752eb401e5	31f4d510-9d46-488a-a7a3-9aef696607a8	2	10	f	\N	649138bf-52fd-4bf0-9564-7f2bf715632c
3ce39cdc-4945-471a-9082-9b45689d8f1f	\N	\N	e42af33c-a898-43d7-a74a-41752eb401e5	31f4d510-9d46-488a-a7a3-9aef696607a8	2	20	t	939dd146-06eb-48c9-abab-172db39e5e21	\N
f829aae7-3008-464c-96c8-0b08a7749703	\N	idp-confirm-link	e42af33c-a898-43d7-a74a-41752eb401e5	939dd146-06eb-48c9-abab-172db39e5e21	0	10	f	\N	\N
e667e9c2-a86e-4ce2-bad1-af61243ee1d9	\N	\N	e42af33c-a898-43d7-a74a-41752eb401e5	939dd146-06eb-48c9-abab-172db39e5e21	0	20	t	38e945fe-2ac2-4635-b5d8-caa81b508283	\N
494e49f7-6bda-443f-a552-fd0ebb9deed3	\N	idp-email-verification	e42af33c-a898-43d7-a74a-41752eb401e5	38e945fe-2ac2-4635-b5d8-caa81b508283	2	10	f	\N	\N
67c98101-db64-4b56-a647-5ce595f43755	\N	\N	e42af33c-a898-43d7-a74a-41752eb401e5	38e945fe-2ac2-4635-b5d8-caa81b508283	2	20	t	d981c76d-ad8a-4ace-a4a8-08b53ae88526	\N
af65d06e-fb3f-4e40-b241-052310081724	\N	idp-username-password-form	e42af33c-a898-43d7-a74a-41752eb401e5	d981c76d-ad8a-4ace-a4a8-08b53ae88526	0	10	f	\N	\N
92c56fa4-aef9-48ba-9b60-de3ee6967d8e	\N	\N	e42af33c-a898-43d7-a74a-41752eb401e5	d981c76d-ad8a-4ace-a4a8-08b53ae88526	1	20	t	8187e853-53e2-43dd-8ab1-f556e69317c6	\N
7cf52804-7bf3-4a53-8c4f-98250f8115a8	\N	conditional-user-configured	e42af33c-a898-43d7-a74a-41752eb401e5	8187e853-53e2-43dd-8ab1-f556e69317c6	0	10	f	\N	\N
fa4c3cdf-39c6-4f14-8f98-7f33950d32ab	\N	auth-otp-form	e42af33c-a898-43d7-a74a-41752eb401e5	8187e853-53e2-43dd-8ab1-f556e69317c6	0	20	f	\N	\N
a97a6bf0-7567-4c61-98ff-acc680f8dc0a	\N	http-basic-authenticator	e42af33c-a898-43d7-a74a-41752eb401e5	8864a658-84b8-4b3d-9ac3-8a603105e56b	0	10	f	\N	\N
1cc83d98-587e-4fdc-8ed9-1f7751ff736a	\N	docker-http-basic-authenticator	e42af33c-a898-43d7-a74a-41752eb401e5	151dfa34-47dd-4296-ac02-8042ccff8493	0	10	f	\N	\N
5bd3319e-e906-4a8c-8065-d65f8a020f52	\N	auth-cookie	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	1674a41f-c9f0-4439-8cd0-cb276864d5ab	2	10	f	\N	\N
bed3e7a4-4e22-4e1a-b112-e85355b6e079	\N	auth-spnego	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	1674a41f-c9f0-4439-8cd0-cb276864d5ab	3	20	f	\N	\N
8634732f-8ffb-4f07-9590-6a905f5a25b7	\N	identity-provider-redirector	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	1674a41f-c9f0-4439-8cd0-cb276864d5ab	2	25	f	\N	\N
e48c3db5-5b4f-4cc4-9866-e5e67cb01347	\N	\N	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	1674a41f-c9f0-4439-8cd0-cb276864d5ab	2	30	t	1b61c73c-e8ae-4f14-ab58-139c4d30237f	\N
fc2b5b12-3031-46ae-8b24-3cef4d87d27d	\N	auth-username-password-form	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	1b61c73c-e8ae-4f14-ab58-139c4d30237f	0	10	f	\N	\N
f19fc1de-9ac8-4704-a14d-c5a25b754e6f	\N	\N	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	1b61c73c-e8ae-4f14-ab58-139c4d30237f	1	20	t	1ba984cc-d521-4259-a186-08cd2cdca076	\N
4bc79d82-038c-48fb-9146-128c6395f5c4	\N	conditional-user-configured	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	1ba984cc-d521-4259-a186-08cd2cdca076	0	10	f	\N	\N
737bcfc7-96ee-434e-9829-0cad2b5dc406	\N	auth-otp-form	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	1ba984cc-d521-4259-a186-08cd2cdca076	0	20	f	\N	\N
2e31f1ea-edb4-4300-bb9b-b4a342af9c9f	\N	direct-grant-validate-username	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	15583ec4-3b3b-4468-a3eb-d6f7defc721d	0	10	f	\N	\N
0846bb70-c03d-4564-8049-9c992b6b187d	\N	direct-grant-validate-password	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	15583ec4-3b3b-4468-a3eb-d6f7defc721d	0	20	f	\N	\N
0f42a1ad-2388-484b-9661-3673cba7878d	\N	\N	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	15583ec4-3b3b-4468-a3eb-d6f7defc721d	1	30	t	c9ae1a9e-fd12-4921-b50f-11428a395154	\N
4cf49bfc-afff-42a9-97ba-52cc70eb2576	\N	conditional-user-configured	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	c9ae1a9e-fd12-4921-b50f-11428a395154	0	10	f	\N	\N
8030ea1c-b9c5-4e19-ae09-d1c087dfc142	\N	direct-grant-validate-otp	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	c9ae1a9e-fd12-4921-b50f-11428a395154	0	20	f	\N	\N
82a88564-09ab-4b2c-ab2a-368072e53297	\N	registration-page-form	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	c6e70676-5639-484b-a267-8b678043f35c	0	10	t	666a9558-6d7a-49a9-bd8d-ba58e06fca39	\N
6cae9057-edaf-46dd-a672-4fd6ca9ee32b	\N	registration-user-creation	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	666a9558-6d7a-49a9-bd8d-ba58e06fca39	0	20	f	\N	\N
077315c3-c200-430d-abdd-3857c1ab1c5c	\N	registration-password-action	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	666a9558-6d7a-49a9-bd8d-ba58e06fca39	0	50	f	\N	\N
79305aef-b3e2-49ce-8e36-5ede33559ea4	\N	registration-recaptcha-action	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	666a9558-6d7a-49a9-bd8d-ba58e06fca39	3	60	f	\N	\N
5776c8a5-fcae-4160-8f96-cee96cc7d6b1	\N	registration-terms-and-conditions	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	666a9558-6d7a-49a9-bd8d-ba58e06fca39	3	70	f	\N	\N
8b6fffc1-390b-4c7c-acdd-b062e9ae689f	\N	reset-credentials-choose-user	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	d4844057-e775-483d-81e6-7c42fedaf88a	0	10	f	\N	\N
bbe4831b-6150-466c-8763-2a537c51dbc4	\N	reset-credential-email	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	d4844057-e775-483d-81e6-7c42fedaf88a	0	20	f	\N	\N
ffb9ada4-8a52-4125-8366-88282c91f2b2	\N	reset-password	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	d4844057-e775-483d-81e6-7c42fedaf88a	0	30	f	\N	\N
40d4060c-d914-413b-8b54-bcbb93ba1230	\N	\N	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	d4844057-e775-483d-81e6-7c42fedaf88a	1	40	t	3c41633c-a310-4f29-986f-5580405a2a1b	\N
384a68f5-816a-4ba2-9c31-6294c1ff90b8	\N	conditional-user-configured	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	3c41633c-a310-4f29-986f-5580405a2a1b	0	10	f	\N	\N
73dd9873-58fb-4928-9526-1924eb5a6f89	\N	reset-otp	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	3c41633c-a310-4f29-986f-5580405a2a1b	0	20	f	\N	\N
0263a99c-a55e-4217-8236-99e71494955e	\N	client-secret	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	c4a15dab-f472-4ea4-bc2e-8454df256547	2	10	f	\N	\N
ac7afef9-efa5-4485-a1aa-90289a0fd8c0	\N	client-jwt	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	c4a15dab-f472-4ea4-bc2e-8454df256547	2	20	f	\N	\N
bf118ce2-c626-4af5-aedc-7f9369e3139e	\N	client-secret-jwt	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	c4a15dab-f472-4ea4-bc2e-8454df256547	2	30	f	\N	\N
244b5f0b-d771-4c77-9f79-17e7a2cb45c7	\N	client-x509	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	c4a15dab-f472-4ea4-bc2e-8454df256547	2	40	f	\N	\N
376d27e4-665e-4dfd-a5e9-bd2c0148642e	\N	idp-review-profile	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	0880d953-d169-4c5f-b3df-554566057657	0	10	f	\N	dee57375-0903-4a75-8e6a-62ae455eac55
3d8a0187-7ede-40b5-827e-79d5726bb749	\N	\N	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	0880d953-d169-4c5f-b3df-554566057657	0	20	t	ffb8fef0-5b11-495f-aac3-ed1a54a81a11	\N
04cdc1dd-f621-4927-80aa-c2d747897fab	\N	idp-create-user-if-unique	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	ffb8fef0-5b11-495f-aac3-ed1a54a81a11	2	10	f	\N	32a2d0ee-3bdb-4b07-ad8e-9dfb3488d4cd
ac4f3aa2-ca78-4cbb-9845-41db923e1e19	\N	\N	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	ffb8fef0-5b11-495f-aac3-ed1a54a81a11	2	20	t	c0df35f9-0b05-41ab-957b-5af20aa04227	\N
95b7762f-c567-4f29-8951-193e737ed0f6	\N	idp-confirm-link	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	c0df35f9-0b05-41ab-957b-5af20aa04227	0	10	f	\N	\N
4c2e53fd-21cd-4fe8-8c35-e2cfb6ab7508	\N	\N	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	c0df35f9-0b05-41ab-957b-5af20aa04227	0	20	t	42e6b15b-14a1-43ed-8717-d5fc18cfeb3e	\N
3010d341-06db-4b24-9aac-996ec1b2953a	\N	idp-email-verification	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	42e6b15b-14a1-43ed-8717-d5fc18cfeb3e	2	10	f	\N	\N
bec4607a-4cc6-4df0-8922-ce1ca20b1410	\N	\N	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	42e6b15b-14a1-43ed-8717-d5fc18cfeb3e	2	20	t	8c1585a5-93e0-4e87-a03d-50e4f0927056	\N
6e3efa70-5ecd-404e-8bf3-2a83861ad1b4	\N	idp-username-password-form	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	8c1585a5-93e0-4e87-a03d-50e4f0927056	0	10	f	\N	\N
227d7df0-bf89-47b9-8ccd-edc6e4f8dc59	\N	\N	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	8c1585a5-93e0-4e87-a03d-50e4f0927056	1	20	t	8ad58503-1c40-4bab-9ed8-6569b7e7a215	\N
b46c7560-2735-4e57-a1ff-5b0bef20a3d2	\N	conditional-user-configured	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	8ad58503-1c40-4bab-9ed8-6569b7e7a215	0	10	f	\N	\N
8c5ddc4a-046d-4de3-bf8a-8bbc5b45dd6e	\N	auth-otp-form	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	8ad58503-1c40-4bab-9ed8-6569b7e7a215	0	20	f	\N	\N
395cec36-85af-4ea2-9085-dd797f12c271	\N	http-basic-authenticator	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	40b8cdbb-d0b4-422c-b641-62d8b8210e6d	0	10	f	\N	\N
f440974b-4e46-4d4a-95ba-acae74bc91b3	\N	docker-http-basic-authenticator	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	095456ba-483b-40b6-af07-4c260b1c01d9	0	10	f	\N	\N
\.


--
-- Data for Name: authentication_flow; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authentication_flow (id, alias, description, realm_id, provider_id, top_level, built_in) FROM stdin;
10b4264e-2d4d-4ecf-98f8-a1848f488ad3	browser	browser based authentication	e42af33c-a898-43d7-a74a-41752eb401e5	basic-flow	t	t
7b9e66ce-fdf8-4383-b917-123c6a95811d	forms	Username, password, otp and other auth forms.	e42af33c-a898-43d7-a74a-41752eb401e5	basic-flow	f	t
a77dd05b-bc84-4285-92fe-d8156227871f	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	e42af33c-a898-43d7-a74a-41752eb401e5	basic-flow	f	t
91d89739-c488-4681-b818-5919a01b3f41	direct grant	OpenID Connect Resource Owner Grant	e42af33c-a898-43d7-a74a-41752eb401e5	basic-flow	t	t
261dc4f5-0b1c-4fef-aae8-8be4e2619895	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	e42af33c-a898-43d7-a74a-41752eb401e5	basic-flow	f	t
ea34474c-d836-45a2-bb69-3c24aa5aecc3	registration	registration flow	e42af33c-a898-43d7-a74a-41752eb401e5	basic-flow	t	t
fd90afea-eea5-40ad-b126-32d0ee89ebc8	registration form	registration form	e42af33c-a898-43d7-a74a-41752eb401e5	form-flow	f	t
a3ad244c-0a14-4d76-98ba-9aad17da3ec3	reset credentials	Reset credentials for a user if they forgot their password or something	e42af33c-a898-43d7-a74a-41752eb401e5	basic-flow	t	t
b0306f3d-3f46-41fd-99a1-1897709330ce	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	e42af33c-a898-43d7-a74a-41752eb401e5	basic-flow	f	t
c120b351-6345-4afd-b962-b4cb48be12f4	clients	Base authentication for clients	e42af33c-a898-43d7-a74a-41752eb401e5	client-flow	t	t
a4f88fd1-e081-449e-a104-4056b5bfa4f8	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	e42af33c-a898-43d7-a74a-41752eb401e5	basic-flow	t	t
31f4d510-9d46-488a-a7a3-9aef696607a8	User creation or linking	Flow for the existing/non-existing user alternatives	e42af33c-a898-43d7-a74a-41752eb401e5	basic-flow	f	t
939dd146-06eb-48c9-abab-172db39e5e21	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	e42af33c-a898-43d7-a74a-41752eb401e5	basic-flow	f	t
38e945fe-2ac2-4635-b5d8-caa81b508283	Account verification options	Method with which to verity the existing account	e42af33c-a898-43d7-a74a-41752eb401e5	basic-flow	f	t
d981c76d-ad8a-4ace-a4a8-08b53ae88526	Verify Existing Account by Re-authentication	Reauthentication of existing account	e42af33c-a898-43d7-a74a-41752eb401e5	basic-flow	f	t
8187e853-53e2-43dd-8ab1-f556e69317c6	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	e42af33c-a898-43d7-a74a-41752eb401e5	basic-flow	f	t
8864a658-84b8-4b3d-9ac3-8a603105e56b	saml ecp	SAML ECP Profile Authentication Flow	e42af33c-a898-43d7-a74a-41752eb401e5	basic-flow	t	t
151dfa34-47dd-4296-ac02-8042ccff8493	docker auth	Used by Docker clients to authenticate against the IDP	e42af33c-a898-43d7-a74a-41752eb401e5	basic-flow	t	t
1674a41f-c9f0-4439-8cd0-cb276864d5ab	browser	browser based authentication	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	basic-flow	t	t
1b61c73c-e8ae-4f14-ab58-139c4d30237f	forms	Username, password, otp and other auth forms.	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	basic-flow	f	t
1ba984cc-d521-4259-a186-08cd2cdca076	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	basic-flow	f	t
15583ec4-3b3b-4468-a3eb-d6f7defc721d	direct grant	OpenID Connect Resource Owner Grant	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	basic-flow	t	t
c9ae1a9e-fd12-4921-b50f-11428a395154	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	basic-flow	f	t
c6e70676-5639-484b-a267-8b678043f35c	registration	registration flow	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	basic-flow	t	t
666a9558-6d7a-49a9-bd8d-ba58e06fca39	registration form	registration form	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	form-flow	f	t
d4844057-e775-483d-81e6-7c42fedaf88a	reset credentials	Reset credentials for a user if they forgot their password or something	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	basic-flow	t	t
3c41633c-a310-4f29-986f-5580405a2a1b	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	basic-flow	f	t
c4a15dab-f472-4ea4-bc2e-8454df256547	clients	Base authentication for clients	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	client-flow	t	t
0880d953-d169-4c5f-b3df-554566057657	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	basic-flow	t	t
ffb8fef0-5b11-495f-aac3-ed1a54a81a11	User creation or linking	Flow for the existing/non-existing user alternatives	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	basic-flow	f	t
c0df35f9-0b05-41ab-957b-5af20aa04227	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	basic-flow	f	t
42e6b15b-14a1-43ed-8717-d5fc18cfeb3e	Account verification options	Method with which to verity the existing account	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	basic-flow	f	t
8c1585a5-93e0-4e87-a03d-50e4f0927056	Verify Existing Account by Re-authentication	Reauthentication of existing account	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	basic-flow	f	t
8ad58503-1c40-4bab-9ed8-6569b7e7a215	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	basic-flow	f	t
40b8cdbb-d0b4-422c-b641-62d8b8210e6d	saml ecp	SAML ECP Profile Authentication Flow	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	basic-flow	t	t
095456ba-483b-40b6-af07-4c260b1c01d9	docker auth	Used by Docker clients to authenticate against the IDP	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	basic-flow	t	t
\.


--
-- Data for Name: authenticator_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authenticator_config (id, alias, realm_id) FROM stdin;
a06e95fe-417c-4617-8b3a-432737ebcad7	review profile config	e42af33c-a898-43d7-a74a-41752eb401e5
649138bf-52fd-4bf0-9564-7f2bf715632c	create unique user config	e42af33c-a898-43d7-a74a-41752eb401e5
dee57375-0903-4a75-8e6a-62ae455eac55	review profile config	513ce991-e46b-4e3b-a51e-c03c61f8f1ac
32a2d0ee-3bdb-4b07-ad8e-9dfb3488d4cd	create unique user config	513ce991-e46b-4e3b-a51e-c03c61f8f1ac
\.


--
-- Data for Name: authenticator_config_entry; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authenticator_config_entry (authenticator_id, value, name) FROM stdin;
649138bf-52fd-4bf0-9564-7f2bf715632c	false	require.password.update.after.registration
a06e95fe-417c-4617-8b3a-432737ebcad7	missing	update.profile.on.first.login
32a2d0ee-3bdb-4b07-ad8e-9dfb3488d4cd	false	require.password.update.after.registration
dee57375-0903-4a75-8e6a-62ae455eac55	missing	update.profile.on.first.login
\.


--
-- Data for Name: broker_link; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.broker_link (identity_provider, storage_provider_id, realm_id, broker_user_id, broker_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client (id, enabled, full_scope_allowed, client_id, not_before, public_client, secret, base_url, bearer_only, management_url, surrogate_auth_required, realm_id, protocol, node_rereg_timeout, frontchannel_logout, consent_required, name, service_accounts_enabled, client_authenticator_type, root_url, description, registration_token, standard_flow_enabled, implicit_flow_enabled, direct_access_grants_enabled, always_display_in_console) FROM stdin;
04ef44ab-a9da-4f74-83cc-6286f9571307	t	f	master-realm	0	f	\N	\N	t	\N	f	e42af33c-a898-43d7-a74a-41752eb401e5	\N	0	f	f	master Realm	f	client-secret	\N	\N	\N	t	f	f	f
9705949f-ee65-4669-ab9a-97d66354880f	t	f	account	0	t	\N	/realms/master/account/	f	\N	f	e42af33c-a898-43d7-a74a-41752eb401e5	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
274c18c2-3acb-4828-8113-a49c994b9349	t	f	account-console	0	t	\N	/realms/master/account/	f	\N	f	e42af33c-a898-43d7-a74a-41752eb401e5	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
55c810d6-12fb-4018-8b74-75c8f5805595	t	f	broker	0	f	\N	\N	t	\N	f	e42af33c-a898-43d7-a74a-41752eb401e5	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
44a76799-b57d-49de-8ef7-a40f36e843c0	t	f	security-admin-console	0	t	\N	/admin/master/console/	f	\N	f	e42af33c-a898-43d7-a74a-41752eb401e5	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
35fbfd20-a36a-4eda-b6ea-539252f44a0c	t	f	admin-cli	0	t	\N	\N	f	\N	f	e42af33c-a898-43d7-a74a-41752eb401e5	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
c1bcfd99-f029-4775-9d65-0db353bbe973	t	f	asrp-realm	0	f	\N	\N	t	\N	f	e42af33c-a898-43d7-a74a-41752eb401e5	\N	0	f	f	asrp Realm	f	client-secret	\N	\N	\N	t	f	f	f
29d23645-b92d-48dc-8015-8ad850505a65	t	f	realm-management	0	f	\N	\N	t	\N	f	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	openid-connect	0	f	f	${client_realm-management}	f	client-secret	\N	\N	\N	t	f	f	f
9d0d9417-47fb-45b2-a9c9-107809fcb94e	t	f	account	0	t	\N	/realms/asrp/account/	f	\N	f	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
86d116d5-00ba-4976-b027-c2c46298f970	t	f	account-console	0	t	\N	/realms/asrp/account/	f	\N	f	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
f82c753f-bbe2-4b40-a8ab-4b10a1d9001b	t	f	broker	0	f	\N	\N	t	\N	f	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
215d5479-a28b-480f-88a4-d119a2ed849a	t	f	security-admin-console	0	t	\N	/admin/asrp/console/	f	\N	f	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
5a7817b0-8114-416b-956e-eb8249d95df0	t	f	admin-cli	0	t	\N	\N	f	\N	f	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
97153c86-824e-4ee5-999b-dc95800acaf8	t	t	asrp-catalog	0	f	vGtLeDwSSnU45vQ0I0weK9rasc27MmXJ		f		f	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	openid-connect	-1	t	f	Catalog API	f	client-secret			\N	f	f	t	f
\.


--
-- Data for Name: client_attributes; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_attributes (client_id, name, value) FROM stdin;
9705949f-ee65-4669-ab9a-97d66354880f	post.logout.redirect.uris	+
274c18c2-3acb-4828-8113-a49c994b9349	post.logout.redirect.uris	+
274c18c2-3acb-4828-8113-a49c994b9349	pkce.code.challenge.method	S256
44a76799-b57d-49de-8ef7-a40f36e843c0	post.logout.redirect.uris	+
44a76799-b57d-49de-8ef7-a40f36e843c0	pkce.code.challenge.method	S256
9d0d9417-47fb-45b2-a9c9-107809fcb94e	post.logout.redirect.uris	+
86d116d5-00ba-4976-b027-c2c46298f970	post.logout.redirect.uris	+
86d116d5-00ba-4976-b027-c2c46298f970	pkce.code.challenge.method	S256
215d5479-a28b-480f-88a4-d119a2ed849a	post.logout.redirect.uris	+
215d5479-a28b-480f-88a4-d119a2ed849a	pkce.code.challenge.method	S256
97153c86-824e-4ee5-999b-dc95800acaf8	client.secret.creation.time	1769000406
97153c86-824e-4ee5-999b-dc95800acaf8	oauth2.device.authorization.grant.enabled	false
97153c86-824e-4ee5-999b-dc95800acaf8	oidc.ciba.grant.enabled	false
97153c86-824e-4ee5-999b-dc95800acaf8	backchannel.logout.session.required	true
97153c86-824e-4ee5-999b-dc95800acaf8	backchannel.logout.revoke.offline.tokens	false
\.


--
-- Data for Name: client_auth_flow_bindings; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_auth_flow_bindings (client_id, flow_id, binding_name) FROM stdin;
\.


--
-- Data for Name: client_initial_access; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_initial_access (id, realm_id, "timestamp", expiration, count, remaining_count) FROM stdin;
\.


--
-- Data for Name: client_node_registrations; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_node_registrations (client_id, value, name) FROM stdin;
\.


--
-- Data for Name: client_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope (id, name, realm_id, description, protocol) FROM stdin;
40e6df66-12f7-4aff-a410-6bcb10d74cbd	offline_access	e42af33c-a898-43d7-a74a-41752eb401e5	OpenID Connect built-in scope: offline_access	openid-connect
ffb15e76-d900-4918-9924-e2232a833653	role_list	e42af33c-a898-43d7-a74a-41752eb401e5	SAML role list	saml
1cc4ff81-e727-49a7-8578-918c15b75774	profile	e42af33c-a898-43d7-a74a-41752eb401e5	OpenID Connect built-in scope: profile	openid-connect
7a90df18-5b0d-40b2-8eed-1c08190e59fb	email	e42af33c-a898-43d7-a74a-41752eb401e5	OpenID Connect built-in scope: email	openid-connect
0fd26979-5fdf-4887-9a4f-bfdafafbc9df	address	e42af33c-a898-43d7-a74a-41752eb401e5	OpenID Connect built-in scope: address	openid-connect
ca74dcc1-cf9a-4810-ae92-7d8c544d9265	phone	e42af33c-a898-43d7-a74a-41752eb401e5	OpenID Connect built-in scope: phone	openid-connect
11767875-a413-4955-86fa-935c1029a643	roles	e42af33c-a898-43d7-a74a-41752eb401e5	OpenID Connect scope for add user roles to the access token	openid-connect
08d4cdd5-4c34-4eb0-8ea1-98255600e9ee	web-origins	e42af33c-a898-43d7-a74a-41752eb401e5	OpenID Connect scope for add allowed web origins to the access token	openid-connect
28d8731d-c25a-4934-983f-d9280231cb87	microprofile-jwt	e42af33c-a898-43d7-a74a-41752eb401e5	Microprofile - JWT built-in scope	openid-connect
77b0de0b-7647-4818-ae87-890961805bea	acr	e42af33c-a898-43d7-a74a-41752eb401e5	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
de935d50-e656-4360-ac35-10d839eb5901	basic	e42af33c-a898-43d7-a74a-41752eb401e5	OpenID Connect scope for add all basic claims to the token	openid-connect
a265d52b-2a3c-4026-9e26-27fa4437a16b	offline_access	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	OpenID Connect built-in scope: offline_access	openid-connect
240442d3-6bd1-4476-b899-9b4f06a531a2	role_list	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	SAML role list	saml
d74d621e-c0cc-4348-9bfe-a180044541ac	profile	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	OpenID Connect built-in scope: profile	openid-connect
af40ed4f-96d1-4804-a958-5787f782374b	email	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	OpenID Connect built-in scope: email	openid-connect
521dda86-387d-40b2-b9cb-ff3005399375	address	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	OpenID Connect built-in scope: address	openid-connect
cdc36ae7-76ba-4648-a134-feb26af64e8a	phone	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	OpenID Connect built-in scope: phone	openid-connect
0faf676f-4fdd-482d-b927-741086d1ae8a	roles	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	OpenID Connect scope for add user roles to the access token	openid-connect
87e8584f-0ca2-4baf-9a3b-f6b5a0240fef	web-origins	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	OpenID Connect scope for add allowed web origins to the access token	openid-connect
51e872f4-53ba-4277-8957-df35c1e73d9b	microprofile-jwt	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	Microprofile - JWT built-in scope	openid-connect
67ab8409-5736-43d9-8730-8178653746ac	acr	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
d92045ce-c747-4e8a-a938-8c8093119274	basic	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	OpenID Connect scope for add all basic claims to the token	openid-connect
\.


--
-- Data for Name: client_scope_attributes; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope_attributes (scope_id, value, name) FROM stdin;
40e6df66-12f7-4aff-a410-6bcb10d74cbd	true	display.on.consent.screen
40e6df66-12f7-4aff-a410-6bcb10d74cbd	${offlineAccessScopeConsentText}	consent.screen.text
ffb15e76-d900-4918-9924-e2232a833653	true	display.on.consent.screen
ffb15e76-d900-4918-9924-e2232a833653	${samlRoleListScopeConsentText}	consent.screen.text
1cc4ff81-e727-49a7-8578-918c15b75774	true	display.on.consent.screen
1cc4ff81-e727-49a7-8578-918c15b75774	${profileScopeConsentText}	consent.screen.text
1cc4ff81-e727-49a7-8578-918c15b75774	true	include.in.token.scope
7a90df18-5b0d-40b2-8eed-1c08190e59fb	true	display.on.consent.screen
7a90df18-5b0d-40b2-8eed-1c08190e59fb	${emailScopeConsentText}	consent.screen.text
7a90df18-5b0d-40b2-8eed-1c08190e59fb	true	include.in.token.scope
0fd26979-5fdf-4887-9a4f-bfdafafbc9df	true	display.on.consent.screen
0fd26979-5fdf-4887-9a4f-bfdafafbc9df	${addressScopeConsentText}	consent.screen.text
0fd26979-5fdf-4887-9a4f-bfdafafbc9df	true	include.in.token.scope
ca74dcc1-cf9a-4810-ae92-7d8c544d9265	true	display.on.consent.screen
ca74dcc1-cf9a-4810-ae92-7d8c544d9265	${phoneScopeConsentText}	consent.screen.text
ca74dcc1-cf9a-4810-ae92-7d8c544d9265	true	include.in.token.scope
11767875-a413-4955-86fa-935c1029a643	true	display.on.consent.screen
11767875-a413-4955-86fa-935c1029a643	${rolesScopeConsentText}	consent.screen.text
11767875-a413-4955-86fa-935c1029a643	false	include.in.token.scope
08d4cdd5-4c34-4eb0-8ea1-98255600e9ee	false	display.on.consent.screen
08d4cdd5-4c34-4eb0-8ea1-98255600e9ee		consent.screen.text
08d4cdd5-4c34-4eb0-8ea1-98255600e9ee	false	include.in.token.scope
28d8731d-c25a-4934-983f-d9280231cb87	false	display.on.consent.screen
28d8731d-c25a-4934-983f-d9280231cb87	true	include.in.token.scope
77b0de0b-7647-4818-ae87-890961805bea	false	display.on.consent.screen
77b0de0b-7647-4818-ae87-890961805bea	false	include.in.token.scope
de935d50-e656-4360-ac35-10d839eb5901	false	display.on.consent.screen
de935d50-e656-4360-ac35-10d839eb5901	false	include.in.token.scope
a265d52b-2a3c-4026-9e26-27fa4437a16b	true	display.on.consent.screen
a265d52b-2a3c-4026-9e26-27fa4437a16b	${offlineAccessScopeConsentText}	consent.screen.text
240442d3-6bd1-4476-b899-9b4f06a531a2	true	display.on.consent.screen
240442d3-6bd1-4476-b899-9b4f06a531a2	${samlRoleListScopeConsentText}	consent.screen.text
d74d621e-c0cc-4348-9bfe-a180044541ac	true	display.on.consent.screen
d74d621e-c0cc-4348-9bfe-a180044541ac	${profileScopeConsentText}	consent.screen.text
d74d621e-c0cc-4348-9bfe-a180044541ac	true	include.in.token.scope
af40ed4f-96d1-4804-a958-5787f782374b	true	display.on.consent.screen
af40ed4f-96d1-4804-a958-5787f782374b	${emailScopeConsentText}	consent.screen.text
af40ed4f-96d1-4804-a958-5787f782374b	true	include.in.token.scope
521dda86-387d-40b2-b9cb-ff3005399375	true	display.on.consent.screen
521dda86-387d-40b2-b9cb-ff3005399375	${addressScopeConsentText}	consent.screen.text
521dda86-387d-40b2-b9cb-ff3005399375	true	include.in.token.scope
cdc36ae7-76ba-4648-a134-feb26af64e8a	true	display.on.consent.screen
cdc36ae7-76ba-4648-a134-feb26af64e8a	${phoneScopeConsentText}	consent.screen.text
cdc36ae7-76ba-4648-a134-feb26af64e8a	true	include.in.token.scope
0faf676f-4fdd-482d-b927-741086d1ae8a	true	display.on.consent.screen
0faf676f-4fdd-482d-b927-741086d1ae8a	${rolesScopeConsentText}	consent.screen.text
0faf676f-4fdd-482d-b927-741086d1ae8a	false	include.in.token.scope
87e8584f-0ca2-4baf-9a3b-f6b5a0240fef	false	display.on.consent.screen
87e8584f-0ca2-4baf-9a3b-f6b5a0240fef		consent.screen.text
87e8584f-0ca2-4baf-9a3b-f6b5a0240fef	false	include.in.token.scope
51e872f4-53ba-4277-8957-df35c1e73d9b	false	display.on.consent.screen
51e872f4-53ba-4277-8957-df35c1e73d9b	true	include.in.token.scope
67ab8409-5736-43d9-8730-8178653746ac	false	display.on.consent.screen
67ab8409-5736-43d9-8730-8178653746ac	false	include.in.token.scope
d92045ce-c747-4e8a-a938-8c8093119274	false	display.on.consent.screen
d92045ce-c747-4e8a-a938-8c8093119274	false	include.in.token.scope
\.


--
-- Data for Name: client_scope_client; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope_client (client_id, scope_id, default_scope) FROM stdin;
9705949f-ee65-4669-ab9a-97d66354880f	de935d50-e656-4360-ac35-10d839eb5901	t
9705949f-ee65-4669-ab9a-97d66354880f	08d4cdd5-4c34-4eb0-8ea1-98255600e9ee	t
9705949f-ee65-4669-ab9a-97d66354880f	77b0de0b-7647-4818-ae87-890961805bea	t
9705949f-ee65-4669-ab9a-97d66354880f	1cc4ff81-e727-49a7-8578-918c15b75774	t
9705949f-ee65-4669-ab9a-97d66354880f	7a90df18-5b0d-40b2-8eed-1c08190e59fb	t
9705949f-ee65-4669-ab9a-97d66354880f	11767875-a413-4955-86fa-935c1029a643	t
9705949f-ee65-4669-ab9a-97d66354880f	28d8731d-c25a-4934-983f-d9280231cb87	f
9705949f-ee65-4669-ab9a-97d66354880f	ca74dcc1-cf9a-4810-ae92-7d8c544d9265	f
9705949f-ee65-4669-ab9a-97d66354880f	0fd26979-5fdf-4887-9a4f-bfdafafbc9df	f
9705949f-ee65-4669-ab9a-97d66354880f	40e6df66-12f7-4aff-a410-6bcb10d74cbd	f
274c18c2-3acb-4828-8113-a49c994b9349	de935d50-e656-4360-ac35-10d839eb5901	t
274c18c2-3acb-4828-8113-a49c994b9349	08d4cdd5-4c34-4eb0-8ea1-98255600e9ee	t
274c18c2-3acb-4828-8113-a49c994b9349	77b0de0b-7647-4818-ae87-890961805bea	t
274c18c2-3acb-4828-8113-a49c994b9349	1cc4ff81-e727-49a7-8578-918c15b75774	t
274c18c2-3acb-4828-8113-a49c994b9349	7a90df18-5b0d-40b2-8eed-1c08190e59fb	t
274c18c2-3acb-4828-8113-a49c994b9349	11767875-a413-4955-86fa-935c1029a643	t
274c18c2-3acb-4828-8113-a49c994b9349	28d8731d-c25a-4934-983f-d9280231cb87	f
274c18c2-3acb-4828-8113-a49c994b9349	ca74dcc1-cf9a-4810-ae92-7d8c544d9265	f
274c18c2-3acb-4828-8113-a49c994b9349	0fd26979-5fdf-4887-9a4f-bfdafafbc9df	f
274c18c2-3acb-4828-8113-a49c994b9349	40e6df66-12f7-4aff-a410-6bcb10d74cbd	f
35fbfd20-a36a-4eda-b6ea-539252f44a0c	de935d50-e656-4360-ac35-10d839eb5901	t
35fbfd20-a36a-4eda-b6ea-539252f44a0c	08d4cdd5-4c34-4eb0-8ea1-98255600e9ee	t
35fbfd20-a36a-4eda-b6ea-539252f44a0c	77b0de0b-7647-4818-ae87-890961805bea	t
35fbfd20-a36a-4eda-b6ea-539252f44a0c	1cc4ff81-e727-49a7-8578-918c15b75774	t
35fbfd20-a36a-4eda-b6ea-539252f44a0c	7a90df18-5b0d-40b2-8eed-1c08190e59fb	t
35fbfd20-a36a-4eda-b6ea-539252f44a0c	11767875-a413-4955-86fa-935c1029a643	t
35fbfd20-a36a-4eda-b6ea-539252f44a0c	28d8731d-c25a-4934-983f-d9280231cb87	f
35fbfd20-a36a-4eda-b6ea-539252f44a0c	ca74dcc1-cf9a-4810-ae92-7d8c544d9265	f
35fbfd20-a36a-4eda-b6ea-539252f44a0c	0fd26979-5fdf-4887-9a4f-bfdafafbc9df	f
35fbfd20-a36a-4eda-b6ea-539252f44a0c	40e6df66-12f7-4aff-a410-6bcb10d74cbd	f
55c810d6-12fb-4018-8b74-75c8f5805595	de935d50-e656-4360-ac35-10d839eb5901	t
55c810d6-12fb-4018-8b74-75c8f5805595	08d4cdd5-4c34-4eb0-8ea1-98255600e9ee	t
55c810d6-12fb-4018-8b74-75c8f5805595	77b0de0b-7647-4818-ae87-890961805bea	t
55c810d6-12fb-4018-8b74-75c8f5805595	1cc4ff81-e727-49a7-8578-918c15b75774	t
55c810d6-12fb-4018-8b74-75c8f5805595	7a90df18-5b0d-40b2-8eed-1c08190e59fb	t
55c810d6-12fb-4018-8b74-75c8f5805595	11767875-a413-4955-86fa-935c1029a643	t
55c810d6-12fb-4018-8b74-75c8f5805595	28d8731d-c25a-4934-983f-d9280231cb87	f
55c810d6-12fb-4018-8b74-75c8f5805595	ca74dcc1-cf9a-4810-ae92-7d8c544d9265	f
55c810d6-12fb-4018-8b74-75c8f5805595	0fd26979-5fdf-4887-9a4f-bfdafafbc9df	f
55c810d6-12fb-4018-8b74-75c8f5805595	40e6df66-12f7-4aff-a410-6bcb10d74cbd	f
04ef44ab-a9da-4f74-83cc-6286f9571307	de935d50-e656-4360-ac35-10d839eb5901	t
04ef44ab-a9da-4f74-83cc-6286f9571307	08d4cdd5-4c34-4eb0-8ea1-98255600e9ee	t
04ef44ab-a9da-4f74-83cc-6286f9571307	77b0de0b-7647-4818-ae87-890961805bea	t
04ef44ab-a9da-4f74-83cc-6286f9571307	1cc4ff81-e727-49a7-8578-918c15b75774	t
04ef44ab-a9da-4f74-83cc-6286f9571307	7a90df18-5b0d-40b2-8eed-1c08190e59fb	t
04ef44ab-a9da-4f74-83cc-6286f9571307	11767875-a413-4955-86fa-935c1029a643	t
04ef44ab-a9da-4f74-83cc-6286f9571307	28d8731d-c25a-4934-983f-d9280231cb87	f
04ef44ab-a9da-4f74-83cc-6286f9571307	ca74dcc1-cf9a-4810-ae92-7d8c544d9265	f
04ef44ab-a9da-4f74-83cc-6286f9571307	0fd26979-5fdf-4887-9a4f-bfdafafbc9df	f
04ef44ab-a9da-4f74-83cc-6286f9571307	40e6df66-12f7-4aff-a410-6bcb10d74cbd	f
44a76799-b57d-49de-8ef7-a40f36e843c0	de935d50-e656-4360-ac35-10d839eb5901	t
44a76799-b57d-49de-8ef7-a40f36e843c0	08d4cdd5-4c34-4eb0-8ea1-98255600e9ee	t
44a76799-b57d-49de-8ef7-a40f36e843c0	77b0de0b-7647-4818-ae87-890961805bea	t
44a76799-b57d-49de-8ef7-a40f36e843c0	1cc4ff81-e727-49a7-8578-918c15b75774	t
44a76799-b57d-49de-8ef7-a40f36e843c0	7a90df18-5b0d-40b2-8eed-1c08190e59fb	t
44a76799-b57d-49de-8ef7-a40f36e843c0	11767875-a413-4955-86fa-935c1029a643	t
44a76799-b57d-49de-8ef7-a40f36e843c0	28d8731d-c25a-4934-983f-d9280231cb87	f
44a76799-b57d-49de-8ef7-a40f36e843c0	ca74dcc1-cf9a-4810-ae92-7d8c544d9265	f
44a76799-b57d-49de-8ef7-a40f36e843c0	0fd26979-5fdf-4887-9a4f-bfdafafbc9df	f
44a76799-b57d-49de-8ef7-a40f36e843c0	40e6df66-12f7-4aff-a410-6bcb10d74cbd	f
9d0d9417-47fb-45b2-a9c9-107809fcb94e	d74d621e-c0cc-4348-9bfe-a180044541ac	t
9d0d9417-47fb-45b2-a9c9-107809fcb94e	87e8584f-0ca2-4baf-9a3b-f6b5a0240fef	t
9d0d9417-47fb-45b2-a9c9-107809fcb94e	67ab8409-5736-43d9-8730-8178653746ac	t
9d0d9417-47fb-45b2-a9c9-107809fcb94e	af40ed4f-96d1-4804-a958-5787f782374b	t
9d0d9417-47fb-45b2-a9c9-107809fcb94e	d92045ce-c747-4e8a-a938-8c8093119274	t
9d0d9417-47fb-45b2-a9c9-107809fcb94e	0faf676f-4fdd-482d-b927-741086d1ae8a	t
9d0d9417-47fb-45b2-a9c9-107809fcb94e	a265d52b-2a3c-4026-9e26-27fa4437a16b	f
9d0d9417-47fb-45b2-a9c9-107809fcb94e	521dda86-387d-40b2-b9cb-ff3005399375	f
9d0d9417-47fb-45b2-a9c9-107809fcb94e	cdc36ae7-76ba-4648-a134-feb26af64e8a	f
9d0d9417-47fb-45b2-a9c9-107809fcb94e	51e872f4-53ba-4277-8957-df35c1e73d9b	f
86d116d5-00ba-4976-b027-c2c46298f970	d74d621e-c0cc-4348-9bfe-a180044541ac	t
86d116d5-00ba-4976-b027-c2c46298f970	87e8584f-0ca2-4baf-9a3b-f6b5a0240fef	t
86d116d5-00ba-4976-b027-c2c46298f970	67ab8409-5736-43d9-8730-8178653746ac	t
86d116d5-00ba-4976-b027-c2c46298f970	af40ed4f-96d1-4804-a958-5787f782374b	t
86d116d5-00ba-4976-b027-c2c46298f970	d92045ce-c747-4e8a-a938-8c8093119274	t
86d116d5-00ba-4976-b027-c2c46298f970	0faf676f-4fdd-482d-b927-741086d1ae8a	t
86d116d5-00ba-4976-b027-c2c46298f970	a265d52b-2a3c-4026-9e26-27fa4437a16b	f
86d116d5-00ba-4976-b027-c2c46298f970	521dda86-387d-40b2-b9cb-ff3005399375	f
86d116d5-00ba-4976-b027-c2c46298f970	cdc36ae7-76ba-4648-a134-feb26af64e8a	f
86d116d5-00ba-4976-b027-c2c46298f970	51e872f4-53ba-4277-8957-df35c1e73d9b	f
5a7817b0-8114-416b-956e-eb8249d95df0	d74d621e-c0cc-4348-9bfe-a180044541ac	t
5a7817b0-8114-416b-956e-eb8249d95df0	87e8584f-0ca2-4baf-9a3b-f6b5a0240fef	t
5a7817b0-8114-416b-956e-eb8249d95df0	67ab8409-5736-43d9-8730-8178653746ac	t
5a7817b0-8114-416b-956e-eb8249d95df0	af40ed4f-96d1-4804-a958-5787f782374b	t
5a7817b0-8114-416b-956e-eb8249d95df0	d92045ce-c747-4e8a-a938-8c8093119274	t
5a7817b0-8114-416b-956e-eb8249d95df0	0faf676f-4fdd-482d-b927-741086d1ae8a	t
5a7817b0-8114-416b-956e-eb8249d95df0	a265d52b-2a3c-4026-9e26-27fa4437a16b	f
5a7817b0-8114-416b-956e-eb8249d95df0	521dda86-387d-40b2-b9cb-ff3005399375	f
5a7817b0-8114-416b-956e-eb8249d95df0	cdc36ae7-76ba-4648-a134-feb26af64e8a	f
5a7817b0-8114-416b-956e-eb8249d95df0	51e872f4-53ba-4277-8957-df35c1e73d9b	f
f82c753f-bbe2-4b40-a8ab-4b10a1d9001b	d74d621e-c0cc-4348-9bfe-a180044541ac	t
f82c753f-bbe2-4b40-a8ab-4b10a1d9001b	87e8584f-0ca2-4baf-9a3b-f6b5a0240fef	t
f82c753f-bbe2-4b40-a8ab-4b10a1d9001b	67ab8409-5736-43d9-8730-8178653746ac	t
f82c753f-bbe2-4b40-a8ab-4b10a1d9001b	af40ed4f-96d1-4804-a958-5787f782374b	t
f82c753f-bbe2-4b40-a8ab-4b10a1d9001b	d92045ce-c747-4e8a-a938-8c8093119274	t
f82c753f-bbe2-4b40-a8ab-4b10a1d9001b	0faf676f-4fdd-482d-b927-741086d1ae8a	t
f82c753f-bbe2-4b40-a8ab-4b10a1d9001b	a265d52b-2a3c-4026-9e26-27fa4437a16b	f
f82c753f-bbe2-4b40-a8ab-4b10a1d9001b	521dda86-387d-40b2-b9cb-ff3005399375	f
f82c753f-bbe2-4b40-a8ab-4b10a1d9001b	cdc36ae7-76ba-4648-a134-feb26af64e8a	f
f82c753f-bbe2-4b40-a8ab-4b10a1d9001b	51e872f4-53ba-4277-8957-df35c1e73d9b	f
29d23645-b92d-48dc-8015-8ad850505a65	d74d621e-c0cc-4348-9bfe-a180044541ac	t
29d23645-b92d-48dc-8015-8ad850505a65	87e8584f-0ca2-4baf-9a3b-f6b5a0240fef	t
29d23645-b92d-48dc-8015-8ad850505a65	67ab8409-5736-43d9-8730-8178653746ac	t
29d23645-b92d-48dc-8015-8ad850505a65	af40ed4f-96d1-4804-a958-5787f782374b	t
29d23645-b92d-48dc-8015-8ad850505a65	d92045ce-c747-4e8a-a938-8c8093119274	t
29d23645-b92d-48dc-8015-8ad850505a65	0faf676f-4fdd-482d-b927-741086d1ae8a	t
29d23645-b92d-48dc-8015-8ad850505a65	a265d52b-2a3c-4026-9e26-27fa4437a16b	f
29d23645-b92d-48dc-8015-8ad850505a65	521dda86-387d-40b2-b9cb-ff3005399375	f
29d23645-b92d-48dc-8015-8ad850505a65	cdc36ae7-76ba-4648-a134-feb26af64e8a	f
29d23645-b92d-48dc-8015-8ad850505a65	51e872f4-53ba-4277-8957-df35c1e73d9b	f
215d5479-a28b-480f-88a4-d119a2ed849a	d74d621e-c0cc-4348-9bfe-a180044541ac	t
215d5479-a28b-480f-88a4-d119a2ed849a	87e8584f-0ca2-4baf-9a3b-f6b5a0240fef	t
215d5479-a28b-480f-88a4-d119a2ed849a	67ab8409-5736-43d9-8730-8178653746ac	t
215d5479-a28b-480f-88a4-d119a2ed849a	af40ed4f-96d1-4804-a958-5787f782374b	t
215d5479-a28b-480f-88a4-d119a2ed849a	d92045ce-c747-4e8a-a938-8c8093119274	t
215d5479-a28b-480f-88a4-d119a2ed849a	0faf676f-4fdd-482d-b927-741086d1ae8a	t
215d5479-a28b-480f-88a4-d119a2ed849a	a265d52b-2a3c-4026-9e26-27fa4437a16b	f
215d5479-a28b-480f-88a4-d119a2ed849a	521dda86-387d-40b2-b9cb-ff3005399375	f
215d5479-a28b-480f-88a4-d119a2ed849a	cdc36ae7-76ba-4648-a134-feb26af64e8a	f
215d5479-a28b-480f-88a4-d119a2ed849a	51e872f4-53ba-4277-8957-df35c1e73d9b	f
97153c86-824e-4ee5-999b-dc95800acaf8	d74d621e-c0cc-4348-9bfe-a180044541ac	t
97153c86-824e-4ee5-999b-dc95800acaf8	87e8584f-0ca2-4baf-9a3b-f6b5a0240fef	t
97153c86-824e-4ee5-999b-dc95800acaf8	67ab8409-5736-43d9-8730-8178653746ac	t
97153c86-824e-4ee5-999b-dc95800acaf8	af40ed4f-96d1-4804-a958-5787f782374b	t
97153c86-824e-4ee5-999b-dc95800acaf8	d92045ce-c747-4e8a-a938-8c8093119274	t
97153c86-824e-4ee5-999b-dc95800acaf8	0faf676f-4fdd-482d-b927-741086d1ae8a	t
97153c86-824e-4ee5-999b-dc95800acaf8	a265d52b-2a3c-4026-9e26-27fa4437a16b	f
97153c86-824e-4ee5-999b-dc95800acaf8	521dda86-387d-40b2-b9cb-ff3005399375	f
97153c86-824e-4ee5-999b-dc95800acaf8	cdc36ae7-76ba-4648-a134-feb26af64e8a	f
97153c86-824e-4ee5-999b-dc95800acaf8	51e872f4-53ba-4277-8957-df35c1e73d9b	f
\.


--
-- Data for Name: client_scope_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope_role_mapping (scope_id, role_id) FROM stdin;
40e6df66-12f7-4aff-a410-6bcb10d74cbd	ffeabf03-f75f-4f12-9956-5ad44f2015a5
a265d52b-2a3c-4026-9e26-27fa4437a16b	ec4caaa0-1506-4e85-b8b0-f9968a13c874
\.


--
-- Data for Name: client_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session (id, client_id, redirect_uri, state, "timestamp", session_id, auth_method, realm_id, auth_user_id, current_action) FROM stdin;
\.


--
-- Data for Name: client_session_auth_status; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session_auth_status (authenticator, status, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_note; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session_note (name, value, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_prot_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session_prot_mapper (protocol_mapper_id, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_role; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session_role (role_id, client_session) FROM stdin;
\.


--
-- Data for Name: client_user_session_note; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_user_session_note (name, value, client_session) FROM stdin;
\.


--
-- Data for Name: component; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.component (id, name, parent_id, provider_id, provider_type, realm_id, sub_type) FROM stdin;
883e6207-8ffa-4e6b-9929-adb7cab16769	Trusted Hosts	e42af33c-a898-43d7-a74a-41752eb401e5	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e42af33c-a898-43d7-a74a-41752eb401e5	anonymous
e2582f46-3ddf-4dc3-802a-0556e44fed35	Consent Required	e42af33c-a898-43d7-a74a-41752eb401e5	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e42af33c-a898-43d7-a74a-41752eb401e5	anonymous
f11317d5-f91b-41d4-9545-8cf3fe374b64	Full Scope Disabled	e42af33c-a898-43d7-a74a-41752eb401e5	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e42af33c-a898-43d7-a74a-41752eb401e5	anonymous
c81e872d-9326-4575-8cbc-4554b9a07295	Max Clients Limit	e42af33c-a898-43d7-a74a-41752eb401e5	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e42af33c-a898-43d7-a74a-41752eb401e5	anonymous
0fa2a613-11ee-4bfb-9682-7d9ae51631a1	Allowed Protocol Mapper Types	e42af33c-a898-43d7-a74a-41752eb401e5	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e42af33c-a898-43d7-a74a-41752eb401e5	anonymous
1042f68b-223f-4e0e-8470-e6882c06b980	Allowed Client Scopes	e42af33c-a898-43d7-a74a-41752eb401e5	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e42af33c-a898-43d7-a74a-41752eb401e5	anonymous
678d4bc2-d702-4423-a692-790040071997	Allowed Protocol Mapper Types	e42af33c-a898-43d7-a74a-41752eb401e5	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e42af33c-a898-43d7-a74a-41752eb401e5	authenticated
a393fb97-9af9-4acd-818b-b6b6e295c153	Allowed Client Scopes	e42af33c-a898-43d7-a74a-41752eb401e5	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e42af33c-a898-43d7-a74a-41752eb401e5	authenticated
f2eda6d4-4430-43f0-a073-7ccfe4b66009	rsa-generated	e42af33c-a898-43d7-a74a-41752eb401e5	rsa-generated	org.keycloak.keys.KeyProvider	e42af33c-a898-43d7-a74a-41752eb401e5	\N
8abec141-b14b-445d-9282-c1020ee5c3d7	rsa-enc-generated	e42af33c-a898-43d7-a74a-41752eb401e5	rsa-enc-generated	org.keycloak.keys.KeyProvider	e42af33c-a898-43d7-a74a-41752eb401e5	\N
cb183f07-f0a6-41c4-ab20-b88281e4d1cc	hmac-generated-hs512	e42af33c-a898-43d7-a74a-41752eb401e5	hmac-generated	org.keycloak.keys.KeyProvider	e42af33c-a898-43d7-a74a-41752eb401e5	\N
c7395ae1-2d57-4e84-8872-c3099d4fbf01	aes-generated	e42af33c-a898-43d7-a74a-41752eb401e5	aes-generated	org.keycloak.keys.KeyProvider	e42af33c-a898-43d7-a74a-41752eb401e5	\N
8d4e8878-b87d-44aa-be9e-9656a963469c	\N	e42af33c-a898-43d7-a74a-41752eb401e5	declarative-user-profile	org.keycloak.userprofile.UserProfileProvider	e42af33c-a898-43d7-a74a-41752eb401e5	\N
0af32aa4-13b3-43b2-8a99-6ceabc5cd077	rsa-generated	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	rsa-generated	org.keycloak.keys.KeyProvider	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	\N
ecd141c8-bfc5-4ec1-bf8d-c8e3b5299baa	rsa-enc-generated	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	rsa-enc-generated	org.keycloak.keys.KeyProvider	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	\N
cbdc5d11-2700-4d48-be58-a028eb763faf	hmac-generated-hs512	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	hmac-generated	org.keycloak.keys.KeyProvider	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	\N
432e6c94-ac67-406c-8b3f-38a2c9da6a02	aes-generated	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	aes-generated	org.keycloak.keys.KeyProvider	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	\N
78152605-32d4-4b75-b867-351ced6794b1	Trusted Hosts	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	anonymous
0ae4048c-a07f-4226-9a05-f58eec5eb8ce	Consent Required	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	anonymous
66af2bcf-b662-44ad-a544-a4dc3da96bc1	Full Scope Disabled	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	anonymous
b9d2152a-ac79-4339-b50e-af9980574392	Max Clients Limit	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	anonymous
04df9790-9962-47fc-b599-26ee99a6ffd8	Allowed Protocol Mapper Types	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	anonymous
fd8c9c22-54c6-40cf-8152-b751e0c2a1d8	Allowed Client Scopes	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	anonymous
59ada2f0-de9f-4c10-90ce-3e80015b3e61	Allowed Protocol Mapper Types	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	authenticated
5bd5e63f-91d9-457b-9362-aa102b5d4c05	Allowed Client Scopes	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	authenticated
\.


--
-- Data for Name: component_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.component_config (id, component_id, name, value) FROM stdin;
9e80383e-3668-4834-b458-9ad6804b1575	a393fb97-9af9-4acd-818b-b6b6e295c153	allow-default-scopes	true
6ca0e08c-0aab-48a6-b6bd-84e0c9324b7e	678d4bc2-d702-4423-a692-790040071997	allowed-protocol-mapper-types	oidc-full-name-mapper
7ccc6d30-dbc0-4f93-b678-c04ec941f3a3	678d4bc2-d702-4423-a692-790040071997	allowed-protocol-mapper-types	oidc-address-mapper
ec68b4bf-de0f-4340-bf57-a2c38a62bc8c	678d4bc2-d702-4423-a692-790040071997	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
87e7893e-423c-4f32-bb4c-8ff0f5d126ce	678d4bc2-d702-4423-a692-790040071997	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
ab4a1eef-4c00-4b2f-a8a3-b4cf44dd8a99	678d4bc2-d702-4423-a692-790040071997	allowed-protocol-mapper-types	saml-role-list-mapper
06a44dbc-6832-4632-aea8-b3f17cea2e9e	678d4bc2-d702-4423-a692-790040071997	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
fb48a448-298c-437b-add1-508f10ed31de	678d4bc2-d702-4423-a692-790040071997	allowed-protocol-mapper-types	saml-user-attribute-mapper
80bb9fa6-74b2-4aef-bcf4-db1d9f9a9767	678d4bc2-d702-4423-a692-790040071997	allowed-protocol-mapper-types	saml-user-property-mapper
1fdc2b78-762c-4cbf-a8dd-615e62a4702a	883e6207-8ffa-4e6b-9929-adb7cab16769	host-sending-registration-request-must-match	true
3e9d14d2-b34d-490d-bdce-5b1ae28907bc	883e6207-8ffa-4e6b-9929-adb7cab16769	client-uris-must-match	true
1693858e-1b11-4372-8ab5-509ddc99515d	c81e872d-9326-4575-8cbc-4554b9a07295	max-clients	200
e2233483-3ef0-47cd-a49a-75c7a5f1a70e	0fa2a613-11ee-4bfb-9682-7d9ae51631a1	allowed-protocol-mapper-types	saml-user-attribute-mapper
f5fe0992-898a-4c3c-afa1-070c41d91ada	0fa2a613-11ee-4bfb-9682-7d9ae51631a1	allowed-protocol-mapper-types	oidc-address-mapper
e32d900a-6819-4831-9d71-322ad55498df	0fa2a613-11ee-4bfb-9682-7d9ae51631a1	allowed-protocol-mapper-types	saml-role-list-mapper
8db2143c-4215-406d-91ee-49432590d36e	0fa2a613-11ee-4bfb-9682-7d9ae51631a1	allowed-protocol-mapper-types	saml-user-property-mapper
b1cf1375-a89b-48f6-b130-356e823464e0	0fa2a613-11ee-4bfb-9682-7d9ae51631a1	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
6aa54610-f092-4088-be40-0f29ccfb177f	0fa2a613-11ee-4bfb-9682-7d9ae51631a1	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
da66f42f-1347-4971-a200-945c2921da44	0fa2a613-11ee-4bfb-9682-7d9ae51631a1	allowed-protocol-mapper-types	oidc-full-name-mapper
ecf9b502-7fe0-4824-ae41-7faee0d4e9bf	0fa2a613-11ee-4bfb-9682-7d9ae51631a1	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
59100410-79ec-4e04-a898-fab4fd6cad5c	1042f68b-223f-4e0e-8470-e6882c06b980	allow-default-scopes	true
79396cc7-fee7-475c-928e-cba6778dcfa9	8d4e8878-b87d-44aa-be9e-9656a963469c	kc.user.profile.config	{"attributes":[{"name":"username","displayName":"${username}","validations":{"length":{"min":3,"max":255},"username-prohibited-characters":{},"up-username-not-idn-homograph":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"email","displayName":"${email}","validations":{"email":{},"length":{"max":255}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"firstName","displayName":"${firstName}","validations":{"length":{"max":255},"person-name-prohibited-characters":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"lastName","displayName":"${lastName}","validations":{"length":{"max":255},"person-name-prohibited-characters":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false}],"groups":[{"name":"user-metadata","displayHeader":"User metadata","displayDescription":"Attributes, which refer to user metadata"}]}
5d2b7423-cac7-4acc-9182-3db0c111b5f4	8abec141-b14b-445d-9282-c1020ee5c3d7	privateKey	MIIEogIBAAKCAQEAlAimQftJI09sJwrqYrxQk6PbEJPuq88BzWy7nrvoui458bbbKDuCGpL9UISkME4EcNjAdma+6k8zMEBcwrR2bIygtxKysL0rTDM1q7z/Z0ZSBLJqP0YrX/8aKMEK0NM6t0Zmd0nUoDo1tia/0YyYucBFtQUEcgYNRC5+UqgIE9yFd7k1/k1n27ujDSY1PyRXDdakBg5n/FJBb+atHhiLWa6jb0XBDWFpnVLTvVhrpvStNute28IsB4HgcUGFIJ3DDKX1o7Y6hyvt4MojRpm24Cf5Bod7nwdjKHYEinjhy9QxNAYEJDpaogc8rmWM77SOXvYWL2ImEYn08LcZrmCKZQIDAQABAoIBAAOPTGbGJUaQWR6hFpqaAlPjIdzGqDKFjAPe2i4DwSGwuxkxviqgi20jhj6xim7LXX0v7ASc36/r9iRWyr1lK8RJ+ZL6A+FhNyqUZNDCiA1U5Zqo9Bx5DdHAwLhSYX8F+50WATLby/jUjF92gbmQUaSXSipoCE1w7OLQq0LGOUoS8WpCt9yDtRkxOBZKGMUvdHN7xlssXVWFGqPTI25hWpKhugjMfRqGHU7gRfDWn8g7IUP/H0IaIOPRPwixLoBm6UzfTb0SJE/dWQ9yLyGbgHKxwnh7dDE9Xn5NOQO6MVsT/TOPNFLQQusW82uiKPb+upLB2bIiPz+ois1hmVOI7tkCgYEA0P0nMA7MfomGPXqyjedV3G/MkqypFBjPqfxLtxsrEgN4SFO62vygeWMuJQqWSgeWGQ+xMkmXCst7SnpLIqWaMQV73Y2dam/sEGS1L0s8ictgLDzj5in7Uawvgmo1K4NjGKb3PVgUMeZg5mXqreDNzGsY5z19pMqKrmb5Y8PpoKkCgYEAtVVVIP8LyQd7HRlhd9RuZwS8Bh1MNM5T2L8om588YZIUtyMvZB31BZ/Vxx8hViel2xEc7aQkb687U94KDJIkGdz4mfdPi5SiFwKqG2bWUYjYV5Cs49UKEc5IxBLCh5EAmevFFpxX0QobPvcOKlpjIphezoQXn4YjoMBQVlO65V0CgYBfhpdW/Cy02h+mEmNzQX6Zl/CmSo2uRfkF9fCV7bEuNq/QP5V1a2vekFsTS1eO1xDgu69/EOwdXw0n6eZWG+Py7FLF3mlJsYbxp1a6G2W8hl2bWunA1wetOUsuDWXoUdIF/qucOppghLFeHs+6Urs+6OUlLZI0tO/W7/Kmi3JKoQKBgFrK5RrmWNJJCp2hTaogFT9DoZk2JifyfwzxebWh3yvDZtfjqCDq1vn/85wFvD1VELhFM0TRgOTiykPN0x5ENgs1FsyQhaWPwDDhRqb9sKWWbSw65jYVPzt3G/wAoKIcOj7XTBFsKpQiCU5XiSIvq59wx1eD0Agxs7kTUaZHujaJAoGAP+ySD3tom+RIrLjNaCM7xGADP+eOuMnqT56pch9UuLv6wGcp2xXmnVl2FbrkB1tz3zLdrQSwakYRe+RrRDAvWGsPz3dazrSypwRLbdOIdk3oHFqu6JSbqXWzvAhCl/VRLzEKqX3K/wgTUrGxexcoNQQcwZWXEMWm20wTzvBXQEw=
a38d74ea-5443-4959-bc0d-73fb589647f3	8abec141-b14b-445d-9282-c1020ee5c3d7	certificate	MIICmzCCAYMCBgGb4J/5rjANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjYwMTIxMTI1MzU5WhcNMzYwMTIxMTI1NTM5WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCUCKZB+0kjT2wnCupivFCTo9sQk+6rzwHNbLueu+i6LjnxttsoO4Iakv1QhKQwTgRw2MB2Zr7qTzMwQFzCtHZsjKC3ErKwvStMMzWrvP9nRlIEsmo/Ritf/xoowQrQ0zq3RmZ3SdSgOjW2Jr/RjJi5wEW1BQRyBg1ELn5SqAgT3IV3uTX+TWfbu6MNJjU/JFcN1qQGDmf8UkFv5q0eGItZrqNvRcENYWmdUtO9WGum9K02617bwiwHgeBxQYUgncMMpfWjtjqHK+3gyiNGmbbgJ/kGh3ufB2ModgSKeOHL1DE0BgQkOlqiBzyuZYzvtI5e9hYvYiYRifTwtxmuYIplAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAGDPePNr+roB6n1MIG9+ud9w/IssuU8vckZ16j5K8egTY+z9iGVqURUViEaXvqKvNXyZOuHR0nym8RERrSUuxORfCDmPriFGLLW9t84lbbdQ/Qm4wSJbdwoa9qpu9RdgPKdwatIwgYqXr6ctQ7dFrKxWodINrvl03NJdF91I5rg/p5vesX0rzgToiWBmHeOK7jZYWKpekbLPZTeZ0Gwe2IPdmdf4XNHE60Xrr8qsRQibUuTD+mjX9wV+Tv3MoicViHVlLTkXcMslVDDM/dBBUtv8Y22QU3mGK/r0FU7smT+txzif1ttVIDDo4SQ6yJWCDYjEkrIFEmYlFYzj6NgqBKA=
725da569-f1fe-4656-b989-970242e3cb0c	8abec141-b14b-445d-9282-c1020ee5c3d7	keyUse	ENC
16ab8c50-b341-47ef-b263-f66dde851466	8abec141-b14b-445d-9282-c1020ee5c3d7	priority	100
42feb8a1-f3b1-41c5-8a5f-e7cd20e94f4c	8abec141-b14b-445d-9282-c1020ee5c3d7	algorithm	RSA-OAEP
c74b11d1-e8d2-45e4-b42d-2df7520ba771	cb183f07-f0a6-41c4-ab20-b88281e4d1cc	secret	0-aDkYEMnCuCE76euoSBQCQCV-54CHaBu2XixryxZ5JwbK7cgP7LL5sJBlzEwS9WJdzExjxN1e8ZczxvfqL4E-Sx-75kFS9bJgf6lQkOmt5WgDk0I1qPhXzIiOTaHelf4ZyqWUNQPyyK9IPJhfritNElsVcthI9UlXDyFySaKY0
43313225-3948-45fe-8a02-132fc39c94d9	cb183f07-f0a6-41c4-ab20-b88281e4d1cc	algorithm	HS512
eab9f3bd-d596-42d5-989f-16df834ce6f0	cb183f07-f0a6-41c4-ab20-b88281e4d1cc	priority	100
2322ea37-e091-4242-831d-2a51c71d30af	cb183f07-f0a6-41c4-ab20-b88281e4d1cc	kid	a5532b4e-8c83-45fb-8cfc-e7a7fe4d66bc
0f092242-b735-4ac5-b6e0-c2e06f9ec906	f2eda6d4-4430-43f0-a073-7ccfe4b66009	privateKey	MIIEowIBAAKCAQEA0jr/7tfDkWbTUEhWlhUpFOugDm/qoNmCegUJTCRY1kDYDTSiQ/MTTY/0IX4s/mb+xXDfpW6R0sXxLqYZi8ftQ0AscKzsVkELy3Cb1XY6rtfdOgswso7kiRPFuIZ/em6bIW5B8oHv+Wj+mhbFXWWDBJ1FXdVxBteusrv8G7unDJq3QPLIs6Itxf9MIW2MsSbugw4dSVjTVs+S3q498xCWm3XcmeY/kuWvZQrZjbwwh+ptoQ9t3/1b4pp+c4NK+iIomsT/ebV0QiDBrf0mmKcengy6HVGko+chsO4sy2qJT1kawHhCBCx6QHEh7ZIwEsbFieVhzrpnKj65+4y2S5cLewIDAQABAoIBAApDBQEkmRA84620ij1zNPkncz2hKuPFGkBYhJap44g5zBIA8ra8Y8HSeAk2fn3Ai0kZ9GC/3/BY5yfuxap0DNnOhRzO5A5lyGyax5CI395u/QZ7S1o77V3fkDQspIZWZc4g8qkivJMBFARzfhjL/rQ39Q3agFTkLEvfLzQvWb0crZJ/AqAu0pbTU0j73Yoyxwf4HzMR9OhJl/EwdTs4e7eUgu2MEwNvzdwA99jjKQ06eLFxP+mWPXRqobwfiriMUX9ehlrB5VnVHHki0Sb4boZQHx18BHjQbFkJ8zCnyGGXvH9tESK2A6tUzpzd+pMamekHC+C/xBAzZFoc7uZIdxECgYEA72U37oIVazv1Ss2327x1s402a24I8ukerI0J0gYpibkRkY0A7+9XbRVGcpCGstzZTYRBXlky6kuDbBm5aRPr/HPgd0X8xDYZzdokzAc+9VPEzWwmxKMeKuiAv5sTe1XPyN2hEukMEu06ltVbMI5d9xVvQxHYA5UqTo71gWRnDNMCgYEA4M/ravF+dCSS/8giUsLkMBjhmrbO4M8fE2PvnIa7wwQk32l8CIkpe91s3er2b6H7ceesQv7laKel+/adj6BYvVegSvXXkZRF0+C0uDbaE8irM4u0hYIdIyjp7VcnhE07sDj7eG04YXSgGc4k9Qb/AyQeqQmTqM6AVEGspwBdvbkCgYAy0XHGF6ckVF4FuxXEd4Uk0F01AO61Yfc4+deT1esLaVXpZ91DEbOlXFbQCw4M+gTHB8Q4mwbL5avITs2lGK2HsbF8oEbAABwKLryQ8xjSSy4DzWmNZHMK+MAb7Hd+PwEUyrdepEoD2ogNbM0myZH42Xv86NTKLegFNSO4i++0MQKBgQCqXqeoOi980SLd2Mu6MJxBnvmKCDQrxotkZH33/1tX5VIURZqL1XasuheA7kmoO/eUUOAJPaaZc0Ok+TZa3Eej5j5B0KF3YAizEz2hxV/rUk38GEnMS9jNBnqRNVVrPCSZ3fUlRJBPutSB+emkD5M+zCa4L9vJOAWk1MiFHw/rcQKBgBiTmmcQrYFGRTieM9qsQ2dRwL1kPhrTYKG7c3RAhnvF5/iW60wbeQQNmlkxNsOilwNdi68FN65jdWud7sV/YMeMC89sWJDq8SzH69GNzUqEpjgYUeqJ2AZX8p27HxfObOpoxBkjn/hmz0NJroe27EGWPXHB/HPFrbPjzh6rn4Er
fe8f030d-bc9e-4f83-b28a-d489cbc45104	f2eda6d4-4430-43f0-a073-7ccfe4b66009	certificate	MIICmzCCAYMCBgGb4J/4pjANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjYwMTIxMTI1MzU4WhcNMzYwMTIxMTI1NTM4WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDSOv/u18ORZtNQSFaWFSkU66AOb+qg2YJ6BQlMJFjWQNgNNKJD8xNNj/Qhfiz+Zv7FcN+lbpHSxfEuphmLx+1DQCxwrOxWQQvLcJvVdjqu1906CzCyjuSJE8W4hn96bpshbkHyge/5aP6aFsVdZYMEnUVd1XEG166yu/wbu6cMmrdA8sizoi3F/0whbYyxJu6DDh1JWNNWz5Lerj3zEJabddyZ5j+S5a9lCtmNvDCH6m2hD23f/Vvimn5zg0r6IiiaxP95tXRCIMGt/SaYpx6eDLodUaSj5yGw7izLaolPWRrAeEIELHpAcSHtkjASxsWJ5WHOumcqPrn7jLZLlwt7AgMBAAEwDQYJKoZIhvcNAQELBQADggEBAJh3PDUT/7vB1LPrwqa683lvsn2XVYQmxtZs2+toF9E2wPznhhyo+l+sFEIBEIr0Fw4bfC8mR7KMW6wUMndQ3SaOYftpT3wMyxkZpfydIDk9V88c89KO/PEV19LNh4kZxLeQwU6kXM2zzSkQHIRS+G6iGvRVMfDWrA/cyXbGv6Mj8k7z+3BbvRaLFo9o+KQo2tVsLzmdd/XV86K6TEYOKJbUcUR0GQS9TpAkaNsTJdNgWTpcIHjA64J6rkSEyIMDe+IgVWHYukthqvNcWg0sP9YjOIKOaTI2rr2yeob9LeVcxckPZeRi6mN9q+tG5mmYPjLRs4LgjGDuLO9cVMvtzTI=
404a19c6-f395-4704-beeb-56ad1f684ff4	f2eda6d4-4430-43f0-a073-7ccfe4b66009	keyUse	SIG
aa766cea-1ec8-4cdd-b49a-e399652e6be2	f2eda6d4-4430-43f0-a073-7ccfe4b66009	priority	100
d872175f-8f58-4fe5-acd4-b68fb681c0fb	c7395ae1-2d57-4e84-8872-c3099d4fbf01	secret	WTQ5Qcy4yVsi7AnNjWCM4Q
98120a0f-c8a9-46cd-a455-2facc36e84ba	c7395ae1-2d57-4e84-8872-c3099d4fbf01	kid	a08f0a95-c6f5-4d11-85eb-7047c319c1a4
404488c1-150b-4690-afe7-b27664243769	c7395ae1-2d57-4e84-8872-c3099d4fbf01	priority	100
40e07d4e-b6d9-4cbe-b7c9-128daa69ccaf	432e6c94-ac67-406c-8b3f-38a2c9da6a02	kid	d34ce0c8-fd8c-469f-aed4-e132f0e45d4c
1e7bdbbb-984a-4613-bd5b-43a7d2842028	432e6c94-ac67-406c-8b3f-38a2c9da6a02	priority	100
f3179b5e-b5c6-4392-b146-fbf00f6d154a	432e6c94-ac67-406c-8b3f-38a2c9da6a02	secret	wxfeAW0OMuMglPyYan3pdg
b0daa334-393a-4d51-87f0-32d0752fdf49	0af32aa4-13b3-43b2-8a99-6ceabc5cd077	keyUse	SIG
01b5a966-5ef8-455e-9337-516de89835e1	0af32aa4-13b3-43b2-8a99-6ceabc5cd077	priority	100
f09b1159-b49e-4f21-9072-41e05ad3680e	0af32aa4-13b3-43b2-8a99-6ceabc5cd077	certificate	MIIClzCCAX8CBgGb4KFBhzANBgkqhkiG9w0BAQsFADAPMQ0wCwYDVQQDDARhc3JwMB4XDTI2MDEyMTEyNTUyM1oXDTM2MDEyMTEyNTcwM1owDzENMAsGA1UEAwwEYXNycDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMq9zQCsrgmRH/QxdCfxF7LAAFjGATNFMARZl5BTMZYdB4KtzjiZo7/WWF0CKTSWoX74D7BAelSfc0aVx9FJ5e2B/zr4sB+r7TaIoUN7vKyDTWdsz/+IWDB2gVSmj3ccUtUI8AtoLuw1CF2H9eQ4NrANRyZme4rRkCj6e5DPoyDZcuNTxtirKymWsNfS6dN6sUQSFDaWGKs1d+znXXNFX2s8xkTMBi/se/Xk//QfkCnjAiybqWJghzkBRlRb9Is8ylIfqlm5hTiAEaMaUsFNAHGurSIg7dW3KfM71gcy3a8nEh87ScL1IwQ1RmgeYItKOenHjv37iCV9wuJ/QZmb1/UCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAAAloZOgy1sZnxJgEPduCe/98yyJkwGfzKrEZYvLpXC9yOYBHrc33W7DTQAXA8nMcnXRf3qzJ/ON5I6lxpvPy+05MUzR+wFzWTu/HR/q4tUhShHBQv6Cr7GO6Y18IrSSp6qYfmi3HS29ZR2G+yBrMe/RS2XZom33suiCxH5Z+wu9E/dsgboVsJEPEML8A6wYVEYJr+TpLkPRn0M+7BKrcbURFhOM+uojJTdd4t9dpy5/ixkYjL/3FumttrTvd0i8nU/Ei3julOxaLsRcyhR8tfstBZW3NCQ6UqU8HipAITS3/SaKDFc8SUY7aLM+8Mar3RQz5ZQzZZ5qY5SXj30sQqA==
3cfc0527-a573-4b8c-aa39-dba22db80782	0af32aa4-13b3-43b2-8a99-6ceabc5cd077	privateKey	MIIEogIBAAKCAQEAyr3NAKyuCZEf9DF0J/EXssAAWMYBM0UwBFmXkFMxlh0Hgq3OOJmjv9ZYXQIpNJahfvgPsEB6VJ9zRpXH0Unl7YH/OviwH6vtNoihQ3u8rINNZ2zP/4hYMHaBVKaPdxxS1QjwC2gu7DUIXYf15Dg2sA1HJmZ7itGQKPp7kM+jINly41PG2KsrKZaw19Lp03qxRBIUNpYYqzV37Oddc0VfazzGRMwGL+x79eT/9B+QKeMCLJupYmCHOQFGVFv0izzKUh+qWbmFOIARoxpSwU0Aca6tIiDt1bcp8zvWBzLdrycSHztJwvUjBDVGaB5gi0o56ceO/fuIJX3C4n9BmZvX9QIDAQABAoIBADl/6RNm5hkqgrCEEhh95SW6FJ8Y0SBUYBDrw/OX1LlpVEb4ukMNOAbhaMBAK6WRjw3ulqx7LPaxHkWHl1tBJSfeNZ/pBjKFVUqhJ3N3NYSL3LkXgEpNxg1Ant9+ObQjYU6wMTxa+OvfApdcRx3J36DAs0wtxp4RX1xv5fmlGfPnlmtbEyPtcNDPDJU8v3TXXdBeBowoynMN8LahgXsDAxd9f29L6GvQSFTcJQNWmCtoB2WtVkrDzD1bZeqa6dyhsBhVjA5a0yolsJcRST7k2Yja3ZOZeIpiNj3QqIEC5DbtKiOnwJ3ZKqI+TrqN/XWCltrHd6+yC9kaGLKZparI3YUCgYEA9vRU2Ov0SRmeTeByR5hMwkZnHSiqnzzpeY2V7bIbn4c6PIz8djtSRGPkQdPv6v6WNFzi3+8DhbMW8cFGxMk0veiwspI7olTLwpUOin8H1lpluZ7AHWW7v5UHsSc/rDN9aunA0Fqm0A7Kc3eDPkZYUBFVjLEMjBLr91ZT3fRzQAcCgYEA0irjWVAwcpt3OywHALhWdWtw/tHg3FZeH0g3uH8rZqJfhV5ZmZKqjMhGqBGCahGjV8Q5l9Mq4rz4po1CVAdX/bq9peZUzs8IcDXBZ0Q1+whO4agqVv0QIqa4Y33hWqO1pgppWb+oYScuIF+7IOYd4sZbXBI1d70mU52oErjxcSMCgYB1ztkrImTG+pGqVQgvX1g+1ZcbMeszS7uVYRXE7tJ+p+QAPsGxJVt5hK2/OXuafxjooecZLMxhW632Zl18QwAGGJsylNAeAJWznafyKedzOmyMwE6lt4J5Qn8I49BcNbP+7MQuoRAy8NtjegACFUzL5XkKROvXZq9qrqQTnincwQKBgAWOtsZU1YMiU0vQRTsipL6kIa/LUvvgmMqQ+VA6pKYpIwd+0DW8aCAi56NoGx+86anXeYJnRhoKzzRwRdG9A/mkp4Esjw+M7/cvpLabWiYSOSvEa6IzPOr9p6CR4pSoAZSrb8+8vrIa/CBFB8i97QpjHmVX4ewRp2LMp3YfR9srAoGAf9yu69VcfqHLLdiZikYdXLwRVO8WOPhLE8+1yPQw4ouOt2rEMNkvV8YIa5g3C6FmBxs2yVVqfKz+aG1a0Ejr0V80sDOQyR2IaxrwtcZKCWKxouanQBv35Ou1mPystIyAlwIjFCd19YQTx13OOJHbM3zbccxo94tazNotTENw6Ko=
3a700b3c-658e-4388-9da4-e2b333c0396e	ecd141c8-bfc5-4ec1-bf8d-c8e3b5299baa	keyUse	ENC
d41fe703-a732-402e-93ae-f6c1403e2dfc	ecd141c8-bfc5-4ec1-bf8d-c8e3b5299baa	algorithm	RSA-OAEP
af344b48-ce18-4502-9b57-c16694e9bd98	ecd141c8-bfc5-4ec1-bf8d-c8e3b5299baa	certificate	MIIClzCCAX8CBgGb4KFB1jANBgkqhkiG9w0BAQsFADAPMQ0wCwYDVQQDDARhc3JwMB4XDTI2MDEyMTEyNTUyM1oXDTM2MDEyMTEyNTcwM1owDzENMAsGA1UEAwwEYXNycDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAOwbY7BjVLZIcsxtq61FtAkGQSTtMamgl5rQ5Oxugz/Wne8+hVi0bW7Y0HL3PNid+ohpve3A1S7kavWRbkcWz/01wvRZn8WCxg39fjV6eIQ+iVoP7y80WU9V8unatiSPCPqwaIYiGW0tDjsFtW2/8I1ZeI28DVlw0RaeTVATpg0ZYjsNoJxyOJTZTYb7qsx3dv+CVZ2IrEyZBXPDW2JIotUL+UAsG3Scu++D3f2LOg7Pr6mW0Z7f638tzs+bw+e/uviRlIfOeiykbxV+We7EOCHAY0Je11QRMb/5eHJwILA96Ka9nurD6Afim6iUo+H+1GqGGBdr/Es1S2y3oDbahZ0CAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAiodZuIioauyNfMSzUSwO1csiFj2Xw6PbozXG3RX9mUuTI8xLt05xBhrC3Ye6JybMoh+jH/4JA7db1dIo2Zqvx8RspQU3AikicYgXY2Ns9OaZLwL8EUvVPyBxf9df2MXMpRppFP7mTT3yCSnxP9d7GDMfF6rhCPDOY+pFNebfHQ+RSHkeEcCNxbj0ZJ3sHKL4m4SelixOg3w3nprpBd9v8QbLDaMrlY54Y3pC3GkgdDAsFtyXkw6nI88yzfRw9yB/L+7gHcjSzgS4RjL2FxiNuGb7Uqml69xD7MZ6chZtk2H5CpYaAapisGOqi/V3mBpczkn4TncMT9wFbWzdf1jCUw==
5664e772-d032-492d-9f53-c486a99ff239	ecd141c8-bfc5-4ec1-bf8d-c8e3b5299baa	privateKey	MIIEogIBAAKCAQEA7BtjsGNUtkhyzG2rrUW0CQZBJO0xqaCXmtDk7G6DP9ad7z6FWLRtbtjQcvc82J36iGm97cDVLuRq9ZFuRxbP/TXC9FmfxYLGDf1+NXp4hD6JWg/vLzRZT1Xy6dq2JI8I+rBohiIZbS0OOwW1bb/wjVl4jbwNWXDRFp5NUBOmDRliOw2gnHI4lNlNhvuqzHd2/4JVnYisTJkFc8NbYkii1Qv5QCwbdJy774Pd/Ys6Ds+vqZbRnt/rfy3Oz5vD57+6+JGUh856LKRvFX5Z7sQ4IcBjQl7XVBExv/l4cnAgsD3opr2e6sPoB+KbqJSj4f7UaoYYF2v8SzVLbLegNtqFnQIDAQABAoIBAATW5a4Y+YShxOyb90L32BVZRSuPF9xmUZH94+6IScHP63Ca1o8Q/685qKgg/8r6DfqoapkXDnRfTTJXkHjKwGk48vqHZCcSiggbLb0sRsOBjqPDpAwfjBCvh8+Z4olETBOE9L3osNG6jmPQtz1ji96YOpU/iTYcm5FVnesQXaM/qF3N8ZP0BjjxDXqr844sMvD79a3M84yXSIIo+mGEOVn5RTCsMBGNbCqQywnZrd66OcKtI58N802uU3jLZJnYSu2p+pCTITswFlRaLnHPy9Ketr4UPCvkCTbOenBgOHSX88TxwGgW7X7/1w9BT06WSWYERTxxQN6OaJFVNhhR4mcCgYEA+hRNB2zeMmpAPG1Wvv3KPlS4fg9vfA39Bs5Ls1ACe/DWCF7WdFZCITGlqSQrjlQcD2RemkbHqEte8LMRb7ei3+uNJfKmg9qS3jVxpqbnQRHmwfsS9iUsUMET0SZRG9a6MGVaDxqL/XW+cFQduidrHMB+IVHWxM8mg6WfGuDQ3qcCgYEA8bJnc1aRzIr6BxI+e05aEhQtLU1zDenzFnqlzlvpVCdO5OdmKvhV+Ewj6wzOgXB5LcqVmT5y3r579Q2HmsA1QSGd/f/hH8lTxL4HobEhFtjJMMOc8Nfzvitg/Dn8cU2wF8DhQXDd8seNfTO6vvu8aHXbgv6ph6OHtwmNrmsP5hsCgYBeZ3N8rhhjJ8EADraEewHx7cGHtQP87Lrr6syg8D8/0na5yjNiz30/UqKa61CV9iJxnQ4pZzbPzUQV0UNvzP7rUNyDysoZVFXFFJ/GrZL2+W8HI2TRDs9f3MNCXRiZTcITqu8IbJkUIXK2rMpcD61buT7kDSTqPtjnMYqSdvPiWQKBgANUiPZe3/1ogM9uIexDBRywqHqyUX6ElbPelsBEJe/h5sVipta6uzyDmA8aCxJfgVvvKaaF5MFK8JxMxmyMb29pTir8xpZQiNXyJFrG/QS6kfMZDuWGpDYflOOEzQSmpGF/Z9sl+fjpZPqvpsgQ4eSykwa4CY/z4d/Uwt3/XaW3AoGAPqH57YmV8bKiOlsePrxdFNBW3S9OVh76dp4uHKfjerQ76E4mNm7J3SXYyd2A6zQf7Sufu3eneVGvCpfnj1G0BxFUcyTE8fcQ5yFnfX4TB/N3d8wQhl0IooorLsafmdFZMAWzZ6iNzMc0FsDkL1pzb35K5bvz64fphOJjY24uMwE=
0e82c660-eb87-4dd7-a198-a92b8963cdca	ecd141c8-bfc5-4ec1-bf8d-c8e3b5299baa	priority	100
9f24a95b-ffd2-4a00-9233-7b7e35692600	cbdc5d11-2700-4d48-be58-a028eb763faf	secret	FzjLGuem2q28oqRPDf07vX2d0m_OlvrCui-P8774f07yX9T-RLrP5AiQYvisktJM8Chy9UL2mT6SN6O8kJwRCvnqRUgA3aFinimiabjMup8ZnzniWM5h2iFgFrzYYlaDxQu2h8Z9gTrQdnHJuo6JyC44v1L8Z6VWQfyBf_O1hEg
9ac7dc26-9d94-403b-8e58-0e4f5efdd910	cbdc5d11-2700-4d48-be58-a028eb763faf	kid	237206ad-7427-44bb-b439-ecfe0c51fc1f
efb23c8e-ef2e-4fec-86f4-7e6201f382d7	cbdc5d11-2700-4d48-be58-a028eb763faf	priority	100
82e01cbc-7ca0-442e-ac84-8cea14e040e0	cbdc5d11-2700-4d48-be58-a028eb763faf	algorithm	HS512
b5a56425-4c0e-44db-a414-f2196b9d02fb	04df9790-9962-47fc-b599-26ee99a6ffd8	allowed-protocol-mapper-types	oidc-address-mapper
88dabdbd-38d8-4f0a-ac69-1dd041cd0259	04df9790-9962-47fc-b599-26ee99a6ffd8	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
1e16e2d5-98c0-4ee4-b251-6ee7c8335cf7	04df9790-9962-47fc-b599-26ee99a6ffd8	allowed-protocol-mapper-types	saml-role-list-mapper
0436c18e-a87e-48a5-950f-bbec44c418c3	04df9790-9962-47fc-b599-26ee99a6ffd8	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
cc33d4d9-8819-4156-a0a8-37add56d156c	04df9790-9962-47fc-b599-26ee99a6ffd8	allowed-protocol-mapper-types	saml-user-property-mapper
716ba38f-7bc0-42a3-9a02-0f88e1eaa68a	04df9790-9962-47fc-b599-26ee99a6ffd8	allowed-protocol-mapper-types	saml-user-attribute-mapper
c2e2b600-1b97-4083-a32b-09715dc114bf	04df9790-9962-47fc-b599-26ee99a6ffd8	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
4c7e80d4-dc39-4078-9d06-9f0356d70a87	04df9790-9962-47fc-b599-26ee99a6ffd8	allowed-protocol-mapper-types	oidc-full-name-mapper
c8a73526-1aec-43fd-b987-a02b01759d34	fd8c9c22-54c6-40cf-8152-b751e0c2a1d8	allow-default-scopes	true
0a2e52ed-093c-4838-a469-546cd6c2efdf	59ada2f0-de9f-4c10-90ce-3e80015b3e61	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
3bf90d41-43fd-4f32-845d-1a583a28c215	59ada2f0-de9f-4c10-90ce-3e80015b3e61	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
1171766b-4564-4314-9c78-71a56e3573c0	59ada2f0-de9f-4c10-90ce-3e80015b3e61	allowed-protocol-mapper-types	oidc-full-name-mapper
515a657e-3fe0-4181-a36b-aada84c1bc13	59ada2f0-de9f-4c10-90ce-3e80015b3e61	allowed-protocol-mapper-types	saml-role-list-mapper
ab3cab00-d99e-43fb-8896-32a5ee8d66a0	59ada2f0-de9f-4c10-90ce-3e80015b3e61	allowed-protocol-mapper-types	oidc-address-mapper
b00d61a5-5f07-4928-aa8c-15e817f57a97	59ada2f0-de9f-4c10-90ce-3e80015b3e61	allowed-protocol-mapper-types	saml-user-property-mapper
764e5a04-5451-45f1-a09e-6ae0a37b5523	59ada2f0-de9f-4c10-90ce-3e80015b3e61	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
03852334-c643-4939-b58b-d1824d5068e1	59ada2f0-de9f-4c10-90ce-3e80015b3e61	allowed-protocol-mapper-types	saml-user-attribute-mapper
db4ae179-6250-4622-a714-78bed6006715	b9d2152a-ac79-4339-b50e-af9980574392	max-clients	200
974f34d7-a85d-456e-a2cb-2301e72a9aab	78152605-32d4-4b75-b867-351ced6794b1	client-uris-must-match	true
89a2e9b7-eff5-4d00-a96d-04c3bed2d507	78152605-32d4-4b75-b867-351ced6794b1	host-sending-registration-request-must-match	true
c3691587-e09e-498c-8bbc-07cc764e427d	5bd5e63f-91d9-457b-9362-aa102b5d4c05	allow-default-scopes	true
\.


--
-- Data for Name: composite_role; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.composite_role (composite, child_role) FROM stdin;
a7988ea0-58e5-4014-ba01-9e3dcaf78161	03bfbd42-710a-4214-a2da-e0e0d28b7604
a7988ea0-58e5-4014-ba01-9e3dcaf78161	748aee0a-37e4-49e6-b7a0-ac2e89121d07
a7988ea0-58e5-4014-ba01-9e3dcaf78161	716ea81b-112b-4141-8b3d-04d843df0785
a7988ea0-58e5-4014-ba01-9e3dcaf78161	54420468-3570-44bd-8e1b-4e96136d3a9e
a7988ea0-58e5-4014-ba01-9e3dcaf78161	c4d121d6-7f58-4e0d-856b-1347723a50d1
a7988ea0-58e5-4014-ba01-9e3dcaf78161	92497208-ec2f-43ae-b102-825e3ad78678
a7988ea0-58e5-4014-ba01-9e3dcaf78161	1422f84d-2652-4a81-81d2-b9f92a978f49
a7988ea0-58e5-4014-ba01-9e3dcaf78161	bc7b2873-6ddc-44c8-83f3-b71c81c86d21
a7988ea0-58e5-4014-ba01-9e3dcaf78161	39ddc1e2-cf07-4e15-afb6-e903979013f9
a7988ea0-58e5-4014-ba01-9e3dcaf78161	6a9888b9-f243-4409-a1df-6d6e66e8183a
a7988ea0-58e5-4014-ba01-9e3dcaf78161	da2c1f70-d601-4720-90b7-152421c4d8eb
a7988ea0-58e5-4014-ba01-9e3dcaf78161	51b39fba-ebd7-42ca-87b5-64549a9b5e4e
a7988ea0-58e5-4014-ba01-9e3dcaf78161	11e2f628-b435-494c-b2ea-019002734c3a
a7988ea0-58e5-4014-ba01-9e3dcaf78161	e23c5da1-eb3c-4bef-a209-749a26f72515
a7988ea0-58e5-4014-ba01-9e3dcaf78161	e39bf5a9-2627-4efa-9517-819daf44ea1d
a7988ea0-58e5-4014-ba01-9e3dcaf78161	b4260e76-3975-4428-986c-8271c2318cc7
a7988ea0-58e5-4014-ba01-9e3dcaf78161	5b109bf1-7465-40af-a8c8-79b315737adb
a7988ea0-58e5-4014-ba01-9e3dcaf78161	c660ea8d-97cf-49bf-9d79-f609d591029e
54420468-3570-44bd-8e1b-4e96136d3a9e	e39bf5a9-2627-4efa-9517-819daf44ea1d
54420468-3570-44bd-8e1b-4e96136d3a9e	c660ea8d-97cf-49bf-9d79-f609d591029e
c4ab8b5b-22ca-47f4-8d4e-9e923a0e0886	73e61119-7775-4dfa-a195-87633c8a26d6
c4d121d6-7f58-4e0d-856b-1347723a50d1	b4260e76-3975-4428-986c-8271c2318cc7
c4ab8b5b-22ca-47f4-8d4e-9e923a0e0886	7f5317c2-e0ea-49e2-b0d4-da9f46c90c79
7f5317c2-e0ea-49e2-b0d4-da9f46c90c79	357f28ed-4935-46c6-92bc-47cac12b2fc7
58b7d4d0-083e-4f43-a036-10bc4564d38a	b8d2a41c-62dd-45d5-80d8-7e9b7db33b53
a7988ea0-58e5-4014-ba01-9e3dcaf78161	dd641b8e-2cdb-440d-bc74-2f2f07c50d4b
c4ab8b5b-22ca-47f4-8d4e-9e923a0e0886	ffeabf03-f75f-4f12-9956-5ad44f2015a5
c4ab8b5b-22ca-47f4-8d4e-9e923a0e0886	092088a1-ad6c-49f1-adbe-48d051e9fced
a7988ea0-58e5-4014-ba01-9e3dcaf78161	5d84b698-8653-4c2f-b584-4c4769beadef
a7988ea0-58e5-4014-ba01-9e3dcaf78161	5c52c3bd-8543-45d6-8678-0a516f3648d8
a7988ea0-58e5-4014-ba01-9e3dcaf78161	9a0714d0-6335-4a38-a1f4-41e6a048fb10
a7988ea0-58e5-4014-ba01-9e3dcaf78161	f62b4f23-106d-4308-b379-341a7a935479
a7988ea0-58e5-4014-ba01-9e3dcaf78161	b5b1bfb5-3dfc-46eb-87c4-7571f2487d3f
a7988ea0-58e5-4014-ba01-9e3dcaf78161	bc9c63e3-237d-4cf4-b986-2649fe494f85
a7988ea0-58e5-4014-ba01-9e3dcaf78161	7832bc2f-f015-4b0a-bf8b-0fa2900fae2e
a7988ea0-58e5-4014-ba01-9e3dcaf78161	3b3a69a2-c41c-4f67-bee8-1e381e76d29f
a7988ea0-58e5-4014-ba01-9e3dcaf78161	7d8d6529-0427-4625-b072-eb9616a4cb92
a7988ea0-58e5-4014-ba01-9e3dcaf78161	a9bdb46d-630f-4c3d-9151-f3340a19c6f6
a7988ea0-58e5-4014-ba01-9e3dcaf78161	4b3bf52c-36b7-40c2-a1fa-722ea9348816
a7988ea0-58e5-4014-ba01-9e3dcaf78161	bcc9c7a7-0bda-420a-9a3e-a0b4b22178fb
a7988ea0-58e5-4014-ba01-9e3dcaf78161	ccdb7f9f-0ab9-4bf1-840f-abe6de17ac0b
a7988ea0-58e5-4014-ba01-9e3dcaf78161	3eeb7f5a-ad7f-435a-8068-7c2e1a9c9da5
a7988ea0-58e5-4014-ba01-9e3dcaf78161	5fb773f4-bf08-4960-8cfc-1230dc13dbe7
a7988ea0-58e5-4014-ba01-9e3dcaf78161	9fbe85d4-c37d-499c-a5b6-e48cc99f7f4d
a7988ea0-58e5-4014-ba01-9e3dcaf78161	ea28bb81-98a2-470b-bffd-8a05a5013d49
9a0714d0-6335-4a38-a1f4-41e6a048fb10	ea28bb81-98a2-470b-bffd-8a05a5013d49
9a0714d0-6335-4a38-a1f4-41e6a048fb10	3eeb7f5a-ad7f-435a-8068-7c2e1a9c9da5
f62b4f23-106d-4308-b379-341a7a935479	5fb773f4-bf08-4960-8cfc-1230dc13dbe7
f6bbe1c0-1e6f-4c19-b9bd-1ccb78ee5c04	30b056c2-7164-477a-872d-011e4aa10719
f6bbe1c0-1e6f-4c19-b9bd-1ccb78ee5c04	7c3c5bdf-0a75-4c4d-b3e9-4aa615aa6a60
f6bbe1c0-1e6f-4c19-b9bd-1ccb78ee5c04	4e977c78-9179-4569-853f-341511678519
f6bbe1c0-1e6f-4c19-b9bd-1ccb78ee5c04	ebc5b462-1142-45d2-b355-e8113cce880e
f6bbe1c0-1e6f-4c19-b9bd-1ccb78ee5c04	e86af346-c1f6-4f9d-8dc3-95c66c87f213
f6bbe1c0-1e6f-4c19-b9bd-1ccb78ee5c04	1a22f969-01a5-4cc2-816d-946157017a7c
f6bbe1c0-1e6f-4c19-b9bd-1ccb78ee5c04	1a0f49dc-5cc2-40a2-b230-1553dc09b168
f6bbe1c0-1e6f-4c19-b9bd-1ccb78ee5c04	62f26a8d-2cfe-4ad1-b45f-fc77b8e00f27
f6bbe1c0-1e6f-4c19-b9bd-1ccb78ee5c04	acd2d9b6-f83e-4e71-a112-385c3219f30c
f6bbe1c0-1e6f-4c19-b9bd-1ccb78ee5c04	7c3535c7-92d9-4abd-95ed-c965c9a5ec9e
f6bbe1c0-1e6f-4c19-b9bd-1ccb78ee5c04	f18b3c93-17a1-4448-9b14-e5f0a6862e78
f6bbe1c0-1e6f-4c19-b9bd-1ccb78ee5c04	3c2379b2-21ad-4c4a-a563-a6b75bf93c80
f6bbe1c0-1e6f-4c19-b9bd-1ccb78ee5c04	fa1be923-657c-41e0-a2da-309e5c1737eb
f6bbe1c0-1e6f-4c19-b9bd-1ccb78ee5c04	434682cf-3367-4b4c-b04c-d10ae080f9ce
f6bbe1c0-1e6f-4c19-b9bd-1ccb78ee5c04	3be21d5b-2452-419c-a006-0c72af0e33e1
f6bbe1c0-1e6f-4c19-b9bd-1ccb78ee5c04	610d1977-f547-48de-8df1-9c0e0db61ef7
f6bbe1c0-1e6f-4c19-b9bd-1ccb78ee5c04	a42725fa-45c4-4948-aea0-0da8677fe928
4e977c78-9179-4569-853f-341511678519	a42725fa-45c4-4948-aea0-0da8677fe928
4e977c78-9179-4569-853f-341511678519	434682cf-3367-4b4c-b04c-d10ae080f9ce
855f5a56-1c23-4df8-acf5-12666652d32a	a1ae6eff-f867-48ae-8c48-6917681f9796
ebc5b462-1142-45d2-b355-e8113cce880e	3be21d5b-2452-419c-a006-0c72af0e33e1
855f5a56-1c23-4df8-acf5-12666652d32a	3b70e7e8-f6c9-486a-b716-72c89734051b
3b70e7e8-f6c9-486a-b716-72c89734051b	f480f9d5-8442-49e9-9107-82b0456d9590
794a7a32-531c-446a-b545-acaddb40f390	92dc50b7-375c-4a01-901e-ed57a2cac550
a7988ea0-58e5-4014-ba01-9e3dcaf78161	b88907a9-b924-4387-a887-c25bce875386
f6bbe1c0-1e6f-4c19-b9bd-1ccb78ee5c04	50ef8db0-dab0-4ef9-bab3-3d70f4f292cc
855f5a56-1c23-4df8-acf5-12666652d32a	ec4caaa0-1506-4e85-b8b0-f9968a13c874
855f5a56-1c23-4df8-acf5-12666652d32a	5f8fe912-f5cc-43e6-902d-56e7db710d8b
b3ff07b6-ce5b-4d99-a758-2bbf9f0e32fa	f94a4e7f-ab6b-4764-ae8f-f5471ea1da8e
\.


--
-- Data for Name: credential; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.credential (id, salt, type, user_id, created_date, user_label, secret_data, credential_data, priority) FROM stdin;
fdadfd19-ac18-4b47-8636-31ab56cce23b	\N	password	6eb64b5f-a195-432b-8710-4bdab6e82254	1769000140502	\N	{"value":"Jefs8OXUUNMc4Q9HT6cwbe4pp5aFtm1dOH8SV9YhD6g=","salt":"aT3a9kqnvUdQ98eUR8MSLg==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10
16820c61-d513-46bb-b7e3-cdc26476b788	\N	password	b0d3bbef-ad49-4cb9-ba3b-c0a9b255c8ae	1769012036222	My password	{"value":"+X3qKg5XKEbN5qydZUKKvFd+hIwhbAGW97xZiFsron0=","salt":"CSR9MwsEUMVl6OBYeDkeBw==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10
63c73e9b-1cfa-4ef2-ba12-42d14fb6ea80	\N	password	5e3a7290-c388-4929-afa9-1fd63d359842	1769012049695	My password	{"value":"qtD656Jn2AfUB+3wD1Da8gHGwkdPxlJAm3Bl8Ch0ezg=","salt":"sdouELFBcmXDeRYPIztA8w==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10
\.


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/jpa-changelog-1.0.0.Final.xml	2026-01-21 12:55:29.279795	1	EXECUTED	9:6f1016664e21e16d26517a4418f5e3df	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.25.1	\N	\N	9000128029
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/db2-jpa-changelog-1.0.0.Final.xml	2026-01-21 12:55:29.309142	2	MARK_RAN	9:828775b1596a07d1200ba1d49e5e3941	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.25.1	\N	\N	9000128029
1.1.0.Beta1	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Beta1.xml	2026-01-21 12:55:29.414323	3	EXECUTED	9:5f090e44a7d595883c1fb61f4b41fd38	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=CLIENT_ATTRIBUTES; createTable tableName=CLIENT_SESSION_NOTE; createTable tableName=APP_NODE_REGISTRATIONS; addColumn table...		\N	4.25.1	\N	\N	9000128029
1.1.0.Final	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Final.xml	2026-01-21 12:55:29.424193	4	EXECUTED	9:c07e577387a3d2c04d1adc9aaad8730e	renameColumn newColumnName=EVENT_TIME, oldColumnName=TIME, tableName=EVENT_ENTITY		\N	4.25.1	\N	\N	9000128029
1.2.0.Beta1	psilva@redhat.com	META-INF/jpa-changelog-1.2.0.Beta1.xml	2026-01-21 12:55:29.657061	5	EXECUTED	9:b68ce996c655922dbcd2fe6b6ae72686	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.25.1	\N	\N	9000128029
1.2.0.Beta1	psilva@redhat.com	META-INF/db2-jpa-changelog-1.2.0.Beta1.xml	2026-01-21 12:55:29.677611	6	MARK_RAN	9:543b5c9989f024fe35c6f6c5a97de88e	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.25.1	\N	\N	9000128029
1.2.0.RC1	bburke@redhat.com	META-INF/jpa-changelog-1.2.0.CR1.xml	2026-01-21 12:55:29.888993	7	EXECUTED	9:765afebbe21cf5bbca048e632df38336	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.25.1	\N	\N	9000128029
1.2.0.RC1	bburke@redhat.com	META-INF/db2-jpa-changelog-1.2.0.CR1.xml	2026-01-21 12:55:29.906008	8	MARK_RAN	9:db4a145ba11a6fdaefb397f6dbf829a1	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.25.1	\N	\N	9000128029
1.2.0.Final	keycloak	META-INF/jpa-changelog-1.2.0.Final.xml	2026-01-21 12:55:29.920215	9	EXECUTED	9:9d05c7be10cdb873f8bcb41bc3a8ab23	update tableName=CLIENT; update tableName=CLIENT; update tableName=CLIENT		\N	4.25.1	\N	\N	9000128029
1.3.0	bburke@redhat.com	META-INF/jpa-changelog-1.3.0.xml	2026-01-21 12:55:30.206924	10	EXECUTED	9:18593702353128d53111f9b1ff0b82b8	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=ADMI...		\N	4.25.1	\N	\N	9000128029
1.4.0	bburke@redhat.com	META-INF/jpa-changelog-1.4.0.xml	2026-01-21 12:55:30.38212	11	EXECUTED	9:6122efe5f090e41a85c0f1c9e52cbb62	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.25.1	\N	\N	9000128029
1.4.0	bburke@redhat.com	META-INF/db2-jpa-changelog-1.4.0.xml	2026-01-21 12:55:30.393298	12	MARK_RAN	9:e1ff28bf7568451453f844c5d54bb0b5	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.25.1	\N	\N	9000128029
1.5.0	bburke@redhat.com	META-INF/jpa-changelog-1.5.0.xml	2026-01-21 12:55:30.441008	13	EXECUTED	9:7af32cd8957fbc069f796b61217483fd	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.25.1	\N	\N	9000128029
1.6.1_from15	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2026-01-21 12:55:30.494877	14	EXECUTED	9:6005e15e84714cd83226bf7879f54190	addColumn tableName=REALM; addColumn tableName=KEYCLOAK_ROLE; addColumn tableName=CLIENT; createTable tableName=OFFLINE_USER_SESSION; createTable tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_US_SES_PK2, tableName=...		\N	4.25.1	\N	\N	9000128029
1.6.1_from16-pre	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2026-01-21 12:55:30.499559	15	MARK_RAN	9:bf656f5a2b055d07f314431cae76f06c	delete tableName=OFFLINE_CLIENT_SESSION; delete tableName=OFFLINE_USER_SESSION		\N	4.25.1	\N	\N	9000128029
1.6.1_from16	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2026-01-21 12:55:30.506197	16	MARK_RAN	9:f8dadc9284440469dcf71e25ca6ab99b	dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_US_SES_PK, tableName=OFFLINE_USER_SESSION; dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_CL_SES_PK, tableName=OFFLINE_CLIENT_SESSION; addColumn tableName=OFFLINE_USER_SESSION; update tableName=OF...		\N	4.25.1	\N	\N	9000128029
1.6.1	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2026-01-21 12:55:30.513254	17	EXECUTED	9:d41d8cd98f00b204e9800998ecf8427e	empty		\N	4.25.1	\N	\N	9000128029
1.7.0	bburke@redhat.com	META-INF/jpa-changelog-1.7.0.xml	2026-01-21 12:55:30.618771	18	EXECUTED	9:3368ff0be4c2855ee2dd9ca813b38d8e	createTable tableName=KEYCLOAK_GROUP; createTable tableName=GROUP_ROLE_MAPPING; createTable tableName=GROUP_ATTRIBUTE; createTable tableName=USER_GROUP_MEMBERSHIP; createTable tableName=REALM_DEFAULT_GROUPS; addColumn tableName=IDENTITY_PROVIDER; ...		\N	4.25.1	\N	\N	9000128029
1.8.0	mposolda@redhat.com	META-INF/jpa-changelog-1.8.0.xml	2026-01-21 12:55:30.708586	19	EXECUTED	9:8ac2fb5dd030b24c0570a763ed75ed20	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.25.1	\N	\N	9000128029
1.8.0-2	keycloak	META-INF/jpa-changelog-1.8.0.xml	2026-01-21 12:55:30.720531	20	EXECUTED	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.25.1	\N	\N	9000128029
1.8.0	mposolda@redhat.com	META-INF/db2-jpa-changelog-1.8.0.xml	2026-01-21 12:55:30.726149	21	MARK_RAN	9:831e82914316dc8a57dc09d755f23c51	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.25.1	\N	\N	9000128029
1.8.0-2	keycloak	META-INF/db2-jpa-changelog-1.8.0.xml	2026-01-21 12:55:30.73325	22	MARK_RAN	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.25.1	\N	\N	9000128029
1.9.0	mposolda@redhat.com	META-INF/jpa-changelog-1.9.0.xml	2026-01-21 12:55:30.785247	23	EXECUTED	9:bc3d0f9e823a69dc21e23e94c7a94bb1	update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=REALM; update tableName=REALM; customChange; dr...		\N	4.25.1	\N	\N	9000128029
1.9.1	keycloak	META-INF/jpa-changelog-1.9.1.xml	2026-01-21 12:55:30.799338	24	EXECUTED	9:c9999da42f543575ab790e76439a2679	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=PUBLIC_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.25.1	\N	\N	9000128029
1.9.1	keycloak	META-INF/db2-jpa-changelog-1.9.1.xml	2026-01-21 12:55:30.802871	25	MARK_RAN	9:0d6c65c6f58732d81569e77b10ba301d	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.25.1	\N	\N	9000128029
1.9.2	keycloak	META-INF/jpa-changelog-1.9.2.xml	2026-01-21 12:55:30.885352	26	EXECUTED	9:fc576660fc016ae53d2d4778d84d86d0	createIndex indexName=IDX_USER_EMAIL, tableName=USER_ENTITY; createIndex indexName=IDX_USER_ROLE_MAPPING, tableName=USER_ROLE_MAPPING; createIndex indexName=IDX_USER_GROUP_MAPPING, tableName=USER_GROUP_MEMBERSHIP; createIndex indexName=IDX_USER_CO...		\N	4.25.1	\N	\N	9000128029
authz-2.0.0	psilva@redhat.com	META-INF/jpa-changelog-authz-2.0.0.xml	2026-01-21 12:55:31.048767	27	EXECUTED	9:43ed6b0da89ff77206289e87eaa9c024	createTable tableName=RESOURCE_SERVER; addPrimaryKey constraintName=CONSTRAINT_FARS, tableName=RESOURCE_SERVER; addUniqueConstraint constraintName=UK_AU8TT6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER; createTable tableName=RESOURCE_SERVER_RESOU...		\N	4.25.1	\N	\N	9000128029
authz-2.5.1	psilva@redhat.com	META-INF/jpa-changelog-authz-2.5.1.xml	2026-01-21 12:55:31.056137	28	EXECUTED	9:44bae577f551b3738740281eceb4ea70	update tableName=RESOURCE_SERVER_POLICY		\N	4.25.1	\N	\N	9000128029
2.1.0-KEYCLOAK-5461	bburke@redhat.com	META-INF/jpa-changelog-2.1.0.xml	2026-01-21 12:55:31.196751	29	EXECUTED	9:bd88e1f833df0420b01e114533aee5e8	createTable tableName=BROKER_LINK; createTable tableName=FED_USER_ATTRIBUTE; createTable tableName=FED_USER_CONSENT; createTable tableName=FED_USER_CONSENT_ROLE; createTable tableName=FED_USER_CONSENT_PROT_MAPPER; createTable tableName=FED_USER_CR...		\N	4.25.1	\N	\N	9000128029
2.2.0	bburke@redhat.com	META-INF/jpa-changelog-2.2.0.xml	2026-01-21 12:55:31.230809	30	EXECUTED	9:a7022af5267f019d020edfe316ef4371	addColumn tableName=ADMIN_EVENT_ENTITY; createTable tableName=CREDENTIAL_ATTRIBUTE; createTable tableName=FED_CREDENTIAL_ATTRIBUTE; modifyDataType columnName=VALUE, tableName=CREDENTIAL; addForeignKeyConstraint baseTableName=FED_CREDENTIAL_ATTRIBU...		\N	4.25.1	\N	\N	9000128029
2.3.0	bburke@redhat.com	META-INF/jpa-changelog-2.3.0.xml	2026-01-21 12:55:31.286123	31	EXECUTED	9:fc155c394040654d6a79227e56f5e25a	createTable tableName=FEDERATED_USER; addPrimaryKey constraintName=CONSTR_FEDERATED_USER, tableName=FEDERATED_USER; dropDefaultValue columnName=TOTP, tableName=USER_ENTITY; dropColumn columnName=TOTP, tableName=USER_ENTITY; addColumn tableName=IDE...		\N	4.25.1	\N	\N	9000128029
2.4.0	bburke@redhat.com	META-INF/jpa-changelog-2.4.0.xml	2026-01-21 12:55:31.311489	32	EXECUTED	9:eac4ffb2a14795e5dc7b426063e54d88	customChange		\N	4.25.1	\N	\N	9000128029
2.5.0	bburke@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2026-01-21 12:55:31.345781	33	EXECUTED	9:54937c05672568c4c64fc9524c1e9462	customChange; modifyDataType columnName=USER_ID, tableName=OFFLINE_USER_SESSION		\N	4.25.1	\N	\N	9000128029
2.5.0-unicode-oracle	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2026-01-21 12:55:31.355881	34	MARK_RAN	9:3a32bace77c84d7678d035a7f5a8084e	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.25.1	\N	\N	9000128029
2.5.0-unicode-other-dbs	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2026-01-21 12:55:31.500494	35	EXECUTED	9:33d72168746f81f98ae3a1e8e0ca3554	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.25.1	\N	\N	9000128029
2.5.0-duplicate-email-support	slawomir@dabek.name	META-INF/jpa-changelog-2.5.0.xml	2026-01-21 12:55:31.512935	36	EXECUTED	9:61b6d3d7a4c0e0024b0c839da283da0c	addColumn tableName=REALM		\N	4.25.1	\N	\N	9000128029
2.5.0-unique-group-names	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2026-01-21 12:55:31.523721	37	EXECUTED	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.25.1	\N	\N	9000128029
2.5.1	bburke@redhat.com	META-INF/jpa-changelog-2.5.1.xml	2026-01-21 12:55:31.530738	38	EXECUTED	9:a2b870802540cb3faa72098db5388af3	addColumn tableName=FED_USER_CONSENT		\N	4.25.1	\N	\N	9000128029
3.0.0	bburke@redhat.com	META-INF/jpa-changelog-3.0.0.xml	2026-01-21 12:55:31.540248	39	EXECUTED	9:132a67499ba24bcc54fb5cbdcfe7e4c0	addColumn tableName=IDENTITY_PROVIDER		\N	4.25.1	\N	\N	9000128029
3.2.0-fix	keycloak	META-INF/jpa-changelog-3.2.0.xml	2026-01-21 12:55:31.543336	40	MARK_RAN	9:938f894c032f5430f2b0fafb1a243462	addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS		\N	4.25.1	\N	\N	9000128029
3.2.0-fix-with-keycloak-5416	keycloak	META-INF/jpa-changelog-3.2.0.xml	2026-01-21 12:55:31.54982	41	MARK_RAN	9:845c332ff1874dc5d35974b0babf3006	dropIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS; addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS; createIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS		\N	4.25.1	\N	\N	9000128029
3.2.0-fix-offline-sessions	hmlnarik	META-INF/jpa-changelog-3.2.0.xml	2026-01-21 12:55:31.565185	42	EXECUTED	9:fc86359c079781adc577c5a217e4d04c	customChange		\N	4.25.1	\N	\N	9000128029
3.2.0-fixed	keycloak	META-INF/jpa-changelog-3.2.0.xml	2026-01-21 12:55:31.894806	43	EXECUTED	9:59a64800e3c0d09b825f8a3b444fa8f4	addColumn tableName=REALM; dropPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_PK2, tableName=OFFLINE_CLIENT_SESSION; dropColumn columnName=CLIENT_SESSION_ID, tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_P...		\N	4.25.1	\N	\N	9000128029
3.3.0	keycloak	META-INF/jpa-changelog-3.3.0.xml	2026-01-21 12:55:31.909501	44	EXECUTED	9:d48d6da5c6ccf667807f633fe489ce88	addColumn tableName=USER_ENTITY		\N	4.25.1	\N	\N	9000128029
authz-3.4.0.CR1-resource-server-pk-change-part1	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2026-01-21 12:55:31.923497	45	EXECUTED	9:dde36f7973e80d71fceee683bc5d2951	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_RESOURCE; addColumn tableName=RESOURCE_SERVER_SCOPE		\N	4.25.1	\N	\N	9000128029
authz-3.4.0.CR1-resource-server-pk-change-part2-KEYCLOAK-6095	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2026-01-21 12:55:31.941445	46	EXECUTED	9:b855e9b0a406b34fa323235a0cf4f640	customChange		\N	4.25.1	\N	\N	9000128029
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2026-01-21 12:55:31.946309	47	MARK_RAN	9:51abbacd7b416c50c4421a8cabf7927e	dropIndex indexName=IDX_RES_SERV_POL_RES_SERV, tableName=RESOURCE_SERVER_POLICY; dropIndex indexName=IDX_RES_SRV_RES_RES_SRV, tableName=RESOURCE_SERVER_RESOURCE; dropIndex indexName=IDX_RES_SRV_SCOPE_RES_SRV, tableName=RESOURCE_SERVER_SCOPE		\N	4.25.1	\N	\N	9000128029
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed-nodropindex	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2026-01-21 12:55:32.054709	48	EXECUTED	9:bdc99e567b3398bac83263d375aad143	addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_POLICY; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_RESOURCE; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, ...		\N	4.25.1	\N	\N	9000128029
authn-3.4.0.CR1-refresh-token-max-reuse	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2026-01-21 12:55:32.068354	49	EXECUTED	9:d198654156881c46bfba39abd7769e69	addColumn tableName=REALM		\N	4.25.1	\N	\N	9000128029
3.4.0	keycloak	META-INF/jpa-changelog-3.4.0.xml	2026-01-21 12:55:32.194465	50	EXECUTED	9:cfdd8736332ccdd72c5256ccb42335db	addPrimaryKey constraintName=CONSTRAINT_REALM_DEFAULT_ROLES, tableName=REALM_DEFAULT_ROLES; addPrimaryKey constraintName=CONSTRAINT_COMPOSITE_ROLE, tableName=COMPOSITE_ROLE; addPrimaryKey constraintName=CONSTR_REALM_DEFAULT_GROUPS, tableName=REALM...		\N	4.25.1	\N	\N	9000128029
3.4.0-KEYCLOAK-5230	hmlnarik@redhat.com	META-INF/jpa-changelog-3.4.0.xml	2026-01-21 12:55:32.29092	51	EXECUTED	9:7c84de3d9bd84d7f077607c1a4dcb714	createIndex indexName=IDX_FU_ATTRIBUTE, tableName=FED_USER_ATTRIBUTE; createIndex indexName=IDX_FU_CONSENT, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CONSENT_RU, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CREDENTIAL, t...		\N	4.25.1	\N	\N	9000128029
3.4.1	psilva@redhat.com	META-INF/jpa-changelog-3.4.1.xml	2026-01-21 12:55:32.299547	52	EXECUTED	9:5a6bb36cbefb6a9d6928452c0852af2d	modifyDataType columnName=VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	9000128029
3.4.2	keycloak	META-INF/jpa-changelog-3.4.2.xml	2026-01-21 12:55:32.308693	53	EXECUTED	9:8f23e334dbc59f82e0a328373ca6ced0	update tableName=REALM		\N	4.25.1	\N	\N	9000128029
3.4.2-KEYCLOAK-5172	mkanis@redhat.com	META-INF/jpa-changelog-3.4.2.xml	2026-01-21 12:55:32.315986	54	EXECUTED	9:9156214268f09d970cdf0e1564d866af	update tableName=CLIENT		\N	4.25.1	\N	\N	9000128029
4.0.0-KEYCLOAK-6335	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2026-01-21 12:55:32.331307	55	EXECUTED	9:db806613b1ed154826c02610b7dbdf74	createTable tableName=CLIENT_AUTH_FLOW_BINDINGS; addPrimaryKey constraintName=C_CLI_FLOW_BIND, tableName=CLIENT_AUTH_FLOW_BINDINGS		\N	4.25.1	\N	\N	9000128029
4.0.0-CLEANUP-UNUSED-TABLE	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2026-01-21 12:55:32.343353	56	EXECUTED	9:229a041fb72d5beac76bb94a5fa709de	dropTable tableName=CLIENT_IDENTITY_PROV_MAPPING		\N	4.25.1	\N	\N	9000128029
4.0.0-KEYCLOAK-6228	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2026-01-21 12:55:32.397901	57	EXECUTED	9:079899dade9c1e683f26b2aa9ca6ff04	dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; dropNotNullConstraint columnName=CLIENT_ID, tableName=USER_CONSENT; addColumn tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHO...		\N	4.25.1	\N	\N	9000128029
4.0.0-KEYCLOAK-5579-fixed	mposolda@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2026-01-21 12:55:32.671476	58	EXECUTED	9:139b79bcbbfe903bb1c2d2a4dbf001d9	dropForeignKeyConstraint baseTableName=CLIENT_TEMPLATE_ATTRIBUTES, constraintName=FK_CL_TEMPL_ATTR_TEMPL; renameTable newTableName=CLIENT_SCOPE_ATTRIBUTES, oldTableName=CLIENT_TEMPLATE_ATTRIBUTES; renameColumn newColumnName=SCOPE_ID, oldColumnName...		\N	4.25.1	\N	\N	9000128029
authz-4.0.0.CR1	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.CR1.xml	2026-01-21 12:55:32.780212	59	EXECUTED	9:b55738ad889860c625ba2bf483495a04	createTable tableName=RESOURCE_SERVER_PERM_TICKET; addPrimaryKey constraintName=CONSTRAINT_FAPMT, tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRHO213XCX4WNKOG82SSPMT...		\N	4.25.1	\N	\N	9000128029
authz-4.0.0.Beta3	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.Beta3.xml	2026-01-21 12:55:32.79048	60	EXECUTED	9:e0057eac39aa8fc8e09ac6cfa4ae15fe	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRPO2128CX4WNKOG82SSRFY, referencedTableName=RESOURCE_SERVER_POLICY		\N	4.25.1	\N	\N	9000128029
authz-4.2.0.Final	mhajas@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2026-01-21 12:55:32.809119	61	EXECUTED	9:42a33806f3a0443fe0e7feeec821326c	createTable tableName=RESOURCE_URIS; addForeignKeyConstraint baseTableName=RESOURCE_URIS, constraintName=FK_RESOURCE_SERVER_URIS, referencedTableName=RESOURCE_SERVER_RESOURCE; customChange; dropColumn columnName=URI, tableName=RESOURCE_SERVER_RESO...		\N	4.25.1	\N	\N	9000128029
authz-4.2.0.Final-KEYCLOAK-9944	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2026-01-21 12:55:32.820297	62	EXECUTED	9:9968206fca46eecc1f51db9c024bfe56	addPrimaryKey constraintName=CONSTRAINT_RESOUR_URIS_PK, tableName=RESOURCE_URIS		\N	4.25.1	\N	\N	9000128029
4.2.0-KEYCLOAK-6313	wadahiro@gmail.com	META-INF/jpa-changelog-4.2.0.xml	2026-01-21 12:55:32.827384	63	EXECUTED	9:92143a6daea0a3f3b8f598c97ce55c3d	addColumn tableName=REQUIRED_ACTION_PROVIDER		\N	4.25.1	\N	\N	9000128029
4.3.0-KEYCLOAK-7984	wadahiro@gmail.com	META-INF/jpa-changelog-4.3.0.xml	2026-01-21 12:55:32.833344	64	EXECUTED	9:82bab26a27195d889fb0429003b18f40	update tableName=REQUIRED_ACTION_PROVIDER		\N	4.25.1	\N	\N	9000128029
4.6.0-KEYCLOAK-7950	psilva@redhat.com	META-INF/jpa-changelog-4.6.0.xml	2026-01-21 12:55:32.83859	65	EXECUTED	9:e590c88ddc0b38b0ae4249bbfcb5abc3	update tableName=RESOURCE_SERVER_RESOURCE		\N	4.25.1	\N	\N	9000128029
4.6.0-KEYCLOAK-8377	keycloak	META-INF/jpa-changelog-4.6.0.xml	2026-01-21 12:55:32.863558	66	EXECUTED	9:5c1f475536118dbdc38d5d7977950cc0	createTable tableName=ROLE_ATTRIBUTE; addPrimaryKey constraintName=CONSTRAINT_ROLE_ATTRIBUTE_PK, tableName=ROLE_ATTRIBUTE; addForeignKeyConstraint baseTableName=ROLE_ATTRIBUTE, constraintName=FK_ROLE_ATTRIBUTE_ID, referencedTableName=KEYCLOAK_ROLE...		\N	4.25.1	\N	\N	9000128029
4.6.0-KEYCLOAK-8555	gideonray@gmail.com	META-INF/jpa-changelog-4.6.0.xml	2026-01-21 12:55:32.875344	67	EXECUTED	9:e7c9f5f9c4d67ccbbcc215440c718a17	createIndex indexName=IDX_COMPONENT_PROVIDER_TYPE, tableName=COMPONENT		\N	4.25.1	\N	\N	9000128029
4.7.0-KEYCLOAK-1267	sguilhen@redhat.com	META-INF/jpa-changelog-4.7.0.xml	2026-01-21 12:55:32.885427	68	EXECUTED	9:88e0bfdda924690d6f4e430c53447dd5	addColumn tableName=REALM		\N	4.25.1	\N	\N	9000128029
4.7.0-KEYCLOAK-7275	keycloak	META-INF/jpa-changelog-4.7.0.xml	2026-01-21 12:55:32.912263	69	EXECUTED	9:f53177f137e1c46b6a88c59ec1cb5218	renameColumn newColumnName=CREATED_ON, oldColumnName=LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION; addNotNullConstraint columnName=CREATED_ON, tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_USER_SESSION; customChange; createIn...		\N	4.25.1	\N	\N	9000128029
4.8.0-KEYCLOAK-8835	sguilhen@redhat.com	META-INF/jpa-changelog-4.8.0.xml	2026-01-21 12:55:32.931697	70	EXECUTED	9:a74d33da4dc42a37ec27121580d1459f	addNotNullConstraint columnName=SSO_MAX_LIFESPAN_REMEMBER_ME, tableName=REALM; addNotNullConstraint columnName=SSO_IDLE_TIMEOUT_REMEMBER_ME, tableName=REALM		\N	4.25.1	\N	\N	9000128029
authz-7.0.0-KEYCLOAK-10443	psilva@redhat.com	META-INF/jpa-changelog-authz-7.0.0.xml	2026-01-21 12:55:32.941165	71	EXECUTED	9:fd4ade7b90c3b67fae0bfcfcb42dfb5f	addColumn tableName=RESOURCE_SERVER		\N	4.25.1	\N	\N	9000128029
8.0.0-adding-credential-columns	keycloak	META-INF/jpa-changelog-8.0.0.xml	2026-01-21 12:55:32.9579	72	EXECUTED	9:aa072ad090bbba210d8f18781b8cebf4	addColumn tableName=CREDENTIAL; addColumn tableName=FED_USER_CREDENTIAL		\N	4.25.1	\N	\N	9000128029
8.0.0-updating-credential-data-not-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2026-01-21 12:55:32.97495	73	EXECUTED	9:1ae6be29bab7c2aa376f6983b932be37	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.25.1	\N	\N	9000128029
8.0.0-updating-credential-data-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2026-01-21 12:55:32.979833	74	MARK_RAN	9:14706f286953fc9a25286dbd8fb30d97	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.25.1	\N	\N	9000128029
8.0.0-credential-cleanup-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2026-01-21 12:55:33.027644	75	EXECUTED	9:2b9cc12779be32c5b40e2e67711a218b	dropDefaultValue columnName=COUNTER, tableName=CREDENTIAL; dropDefaultValue columnName=DIGITS, tableName=CREDENTIAL; dropDefaultValue columnName=PERIOD, tableName=CREDENTIAL; dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; dropColumn ...		\N	4.25.1	\N	\N	9000128029
8.0.0-resource-tag-support	keycloak	META-INF/jpa-changelog-8.0.0.xml	2026-01-21 12:55:33.042968	76	EXECUTED	9:91fa186ce7a5af127a2d7a91ee083cc5	addColumn tableName=MIGRATION_MODEL; createIndex indexName=IDX_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	4.25.1	\N	\N	9000128029
9.0.0-always-display-client	keycloak	META-INF/jpa-changelog-9.0.0.xml	2026-01-21 12:55:33.051419	77	EXECUTED	9:6335e5c94e83a2639ccd68dd24e2e5ad	addColumn tableName=CLIENT		\N	4.25.1	\N	\N	9000128029
9.0.0-drop-constraints-for-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2026-01-21 12:55:33.056546	78	MARK_RAN	9:6bdb5658951e028bfe16fa0a8228b530	dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5PMT, tableName=RESOURCE_SERVER_PERM_TICKET; dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER_RESOURCE; dropPrimaryKey constraintName=CONSTRAINT_O...		\N	4.25.1	\N	\N	9000128029
9.0.0-increase-column-size-federated-fk	keycloak	META-INF/jpa-changelog-9.0.0.xml	2026-01-21 12:55:33.099398	79	EXECUTED	9:d5bc15a64117ccad481ce8792d4c608f	modifyDataType columnName=CLIENT_ID, tableName=FED_USER_CONSENT; modifyDataType columnName=CLIENT_REALM_CONSTRAINT, tableName=KEYCLOAK_ROLE; modifyDataType columnName=OWNER, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=CLIENT_ID, ta...		\N	4.25.1	\N	\N	9000128029
9.0.0-recreate-constraints-after-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2026-01-21 12:55:33.103489	80	MARK_RAN	9:077cba51999515f4d3e7ad5619ab592c	addNotNullConstraint columnName=CLIENT_ID, tableName=OFFLINE_CLIENT_SESSION; addNotNullConstraint columnName=OWNER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNullConstraint columnName=REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNull...		\N	4.25.1	\N	\N	9000128029
9.0.1-add-index-to-client.client_id	keycloak	META-INF/jpa-changelog-9.0.1.xml	2026-01-21 12:55:33.121447	81	EXECUTED	9:be969f08a163bf47c6b9e9ead8ac2afb	createIndex indexName=IDX_CLIENT_ID, tableName=CLIENT		\N	4.25.1	\N	\N	9000128029
9.0.1-KEYCLOAK-12579-drop-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2026-01-21 12:55:33.126081	82	MARK_RAN	9:6d3bb4408ba5a72f39bd8a0b301ec6e3	dropUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.25.1	\N	\N	9000128029
9.0.1-KEYCLOAK-12579-add-not-null-constraint	keycloak	META-INF/jpa-changelog-9.0.1.xml	2026-01-21 12:55:33.138547	83	EXECUTED	9:966bda61e46bebf3cc39518fbed52fa7	addNotNullConstraint columnName=PARENT_GROUP, tableName=KEYCLOAK_GROUP		\N	4.25.1	\N	\N	9000128029
9.0.1-KEYCLOAK-12579-recreate-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2026-01-21 12:55:33.141988	84	MARK_RAN	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.25.1	\N	\N	9000128029
9.0.1-add-index-to-events	keycloak	META-INF/jpa-changelog-9.0.1.xml	2026-01-21 12:55:33.155257	85	EXECUTED	9:7d93d602352a30c0c317e6a609b56599	createIndex indexName=IDX_EVENT_TIME, tableName=EVENT_ENTITY		\N	4.25.1	\N	\N	9000128029
map-remove-ri	keycloak	META-INF/jpa-changelog-11.0.0.xml	2026-01-21 12:55:33.164347	86	EXECUTED	9:71c5969e6cdd8d7b6f47cebc86d37627	dropForeignKeyConstraint baseTableName=REALM, constraintName=FK_TRAF444KK6QRKMS7N56AIWQ5Y; dropForeignKeyConstraint baseTableName=KEYCLOAK_ROLE, constraintName=FK_KJHO5LE2C0RAL09FL8CM9WFW9		\N	4.25.1	\N	\N	9000128029
map-remove-ri	keycloak	META-INF/jpa-changelog-12.0.0.xml	2026-01-21 12:55:33.177838	87	EXECUTED	9:a9ba7d47f065f041b7da856a81762021	dropForeignKeyConstraint baseTableName=REALM_DEFAULT_GROUPS, constraintName=FK_DEF_GROUPS_GROUP; dropForeignKeyConstraint baseTableName=REALM_DEFAULT_ROLES, constraintName=FK_H4WPD7W4HSOOLNI3H0SW7BTJE; dropForeignKeyConstraint baseTableName=CLIENT...		\N	4.25.1	\N	\N	9000128029
12.1.0-add-realm-localization-table	keycloak	META-INF/jpa-changelog-12.0.0.xml	2026-01-21 12:55:33.197713	88	EXECUTED	9:fffabce2bc01e1a8f5110d5278500065	createTable tableName=REALM_LOCALIZATIONS; addPrimaryKey tableName=REALM_LOCALIZATIONS		\N	4.25.1	\N	\N	9000128029
default-roles	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-01-21 12:55:33.214259	89	EXECUTED	9:fa8a5b5445e3857f4b010bafb5009957	addColumn tableName=REALM; customChange		\N	4.25.1	\N	\N	9000128029
default-roles-cleanup	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-01-21 12:55:33.225958	90	EXECUTED	9:67ac3241df9a8582d591c5ed87125f39	dropTable tableName=REALM_DEFAULT_ROLES; dropTable tableName=CLIENT_DEFAULT_ROLES		\N	4.25.1	\N	\N	9000128029
13.0.0-KEYCLOAK-16844	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-01-21 12:55:33.239973	91	EXECUTED	9:ad1194d66c937e3ffc82386c050ba089	createIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	4.25.1	\N	\N	9000128029
map-remove-ri-13.0.0	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-01-21 12:55:33.261673	92	EXECUTED	9:d9be619d94af5a2f5d07b9f003543b91	dropForeignKeyConstraint baseTableName=DEFAULT_CLIENT_SCOPE, constraintName=FK_R_DEF_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SCOPE_CLIENT, constraintName=FK_C_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SC...		\N	4.25.1	\N	\N	9000128029
13.0.0-KEYCLOAK-17992-drop-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-01-21 12:55:33.267264	93	MARK_RAN	9:544d201116a0fcc5a5da0925fbbc3bde	dropPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CLSCOPE_CL, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CL_CLSCOPE, tableName=CLIENT_SCOPE_CLIENT		\N	4.25.1	\N	\N	9000128029
13.0.0-increase-column-size-federated	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-01-21 12:55:33.296376	94	EXECUTED	9:43c0c1055b6761b4b3e89de76d612ccf	modifyDataType columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; modifyDataType columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT		\N	4.25.1	\N	\N	9000128029
13.0.0-KEYCLOAK-17992-recreate-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-01-21 12:55:33.303999	95	MARK_RAN	9:8bd711fd0330f4fe980494ca43ab1139	addNotNullConstraint columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; addNotNullConstraint columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT; addPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; createIndex indexName=...		\N	4.25.1	\N	\N	9000128029
json-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-01-21 12:55:33.330143	96	EXECUTED	9:e07d2bc0970c348bb06fb63b1f82ddbf	addColumn tableName=REALM_ATTRIBUTE; update tableName=REALM_ATTRIBUTE; dropColumn columnName=VALUE, tableName=REALM_ATTRIBUTE; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=REALM_ATTRIBUTE		\N	4.25.1	\N	\N	9000128029
14.0.0-KEYCLOAK-11019	keycloak	META-INF/jpa-changelog-14.0.0.xml	2026-01-21 12:55:33.364116	97	EXECUTED	9:24fb8611e97f29989bea412aa38d12b7	createIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USER, tableName=OFFLINE_USER_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION		\N	4.25.1	\N	\N	9000128029
14.0.0-KEYCLOAK-18286	keycloak	META-INF/jpa-changelog-14.0.0.xml	2026-01-21 12:55:33.37111	98	MARK_RAN	9:259f89014ce2506ee84740cbf7163aa7	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	9000128029
14.0.0-KEYCLOAK-18286-revert	keycloak	META-INF/jpa-changelog-14.0.0.xml	2026-01-21 12:55:33.402821	99	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	9000128029
14.0.0-KEYCLOAK-18286-supported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2026-01-21 12:55:33.424991	100	EXECUTED	9:60ca84a0f8c94ec8c3504a5a3bc88ee8	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	9000128029
14.0.0-KEYCLOAK-18286-unsupported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2026-01-21 12:55:33.429493	101	MARK_RAN	9:d3d977031d431db16e2c181ce49d73e9	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	9000128029
KEYCLOAK-17267-add-index-to-user-attributes	keycloak	META-INF/jpa-changelog-14.0.0.xml	2026-01-21 12:55:33.451067	102	EXECUTED	9:0b305d8d1277f3a89a0a53a659ad274c	createIndex indexName=IDX_USER_ATTRIBUTE_NAME, tableName=USER_ATTRIBUTE		\N	4.25.1	\N	\N	9000128029
KEYCLOAK-18146-add-saml-art-binding-identifier	keycloak	META-INF/jpa-changelog-14.0.0.xml	2026-01-21 12:55:33.470592	103	EXECUTED	9:2c374ad2cdfe20e2905a84c8fac48460	customChange		\N	4.25.1	\N	\N	9000128029
15.0.0-KEYCLOAK-18467	keycloak	META-INF/jpa-changelog-15.0.0.xml	2026-01-21 12:55:33.49115	104	EXECUTED	9:47a760639ac597360a8219f5b768b4de	addColumn tableName=REALM_LOCALIZATIONS; update tableName=REALM_LOCALIZATIONS; dropColumn columnName=TEXTS, tableName=REALM_LOCALIZATIONS; renameColumn newColumnName=TEXTS, oldColumnName=TEXTS_NEW, tableName=REALM_LOCALIZATIONS; addNotNullConstrai...		\N	4.25.1	\N	\N	9000128029
17.0.0-9562	keycloak	META-INF/jpa-changelog-17.0.0.xml	2026-01-21 12:55:33.503307	105	EXECUTED	9:a6272f0576727dd8cad2522335f5d99e	createIndex indexName=IDX_USER_SERVICE_ACCOUNT, tableName=USER_ENTITY		\N	4.25.1	\N	\N	9000128029
18.0.0-10625-IDX_ADMIN_EVENT_TIME	keycloak	META-INF/jpa-changelog-18.0.0.xml	2026-01-21 12:55:33.517293	106	EXECUTED	9:015479dbd691d9cc8669282f4828c41d	createIndex indexName=IDX_ADMIN_EVENT_TIME, tableName=ADMIN_EVENT_ENTITY		\N	4.25.1	\N	\N	9000128029
18.0.15-30992-index-consent	keycloak	META-INF/jpa-changelog-18.0.15.xml	2026-01-21 12:55:33.535518	107	EXECUTED	9:80071ede7a05604b1f4906f3bf3b00f0	createIndex indexName=IDX_USCONSENT_SCOPE_ID, tableName=USER_CONSENT_CLIENT_SCOPE		\N	4.25.1	\N	\N	9000128029
19.0.0-10135	keycloak	META-INF/jpa-changelog-19.0.0.xml	2026-01-21 12:55:33.547693	108	EXECUTED	9:9518e495fdd22f78ad6425cc30630221	customChange		\N	4.25.1	\N	\N	9000128029
20.0.0-12964-supported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2026-01-21 12:55:33.564092	109	EXECUTED	9:e5f243877199fd96bcc842f27a1656ac	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.25.1	\N	\N	9000128029
20.0.0-12964-unsupported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2026-01-21 12:55:33.56746	110	MARK_RAN	9:1a6fcaa85e20bdeae0a9ce49b41946a5	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.25.1	\N	\N	9000128029
client-attributes-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-20.0.0.xml	2026-01-21 12:55:33.580116	111	EXECUTED	9:3f332e13e90739ed0c35b0b25b7822ca	addColumn tableName=CLIENT_ATTRIBUTES; update tableName=CLIENT_ATTRIBUTES; dropColumn columnName=VALUE, tableName=CLIENT_ATTRIBUTES; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	9000128029
21.0.2-17277	keycloak	META-INF/jpa-changelog-21.0.2.xml	2026-01-21 12:55:33.590091	112	EXECUTED	9:7ee1f7a3fb8f5588f171fb9a6ab623c0	customChange		\N	4.25.1	\N	\N	9000128029
21.1.0-19404	keycloak	META-INF/jpa-changelog-21.1.0.xml	2026-01-21 12:55:33.654412	113	EXECUTED	9:3d7e830b52f33676b9d64f7f2b2ea634	modifyDataType columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=LOGIC, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=POLICY_ENFORCE_MODE, tableName=RESOURCE_SERVER		\N	4.25.1	\N	\N	9000128029
21.1.0-19404-2	keycloak	META-INF/jpa-changelog-21.1.0.xml	2026-01-21 12:55:33.666211	114	MARK_RAN	9:627d032e3ef2c06c0e1f73d2ae25c26c	addColumn tableName=RESOURCE_SERVER_POLICY; update tableName=RESOURCE_SERVER_POLICY; dropColumn columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; renameColumn newColumnName=DECISION_STRATEGY, oldColumnName=DECISION_STRATEGY_NEW, tabl...		\N	4.25.1	\N	\N	9000128029
22.0.0-17484-updated	keycloak	META-INF/jpa-changelog-22.0.0.xml	2026-01-21 12:55:33.694	115	EXECUTED	9:90af0bfd30cafc17b9f4d6eccd92b8b3	customChange		\N	4.25.1	\N	\N	9000128029
22.0.5-24031	keycloak	META-INF/jpa-changelog-22.0.0.xml	2026-01-21 12:55:33.701591	116	MARK_RAN	9:a60d2d7b315ec2d3eba9e2f145f9df28	customChange		\N	4.25.1	\N	\N	9000128029
23.0.0-12062	keycloak	META-INF/jpa-changelog-23.0.0.xml	2026-01-21 12:55:33.727768	117	EXECUTED	9:2168fbe728fec46ae9baf15bf80927b8	addColumn tableName=COMPONENT_CONFIG; update tableName=COMPONENT_CONFIG; dropColumn columnName=VALUE, tableName=COMPONENT_CONFIG; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=COMPONENT_CONFIG		\N	4.25.1	\N	\N	9000128029
23.0.0-17258	keycloak	META-INF/jpa-changelog-23.0.0.xml	2026-01-21 12:55:33.738354	118	EXECUTED	9:36506d679a83bbfda85a27ea1864dca8	addColumn tableName=EVENT_ENTITY		\N	4.25.1	\N	\N	9000128029
24.0.0-9758	keycloak	META-INF/jpa-changelog-24.0.0.xml	2026-01-21 12:55:33.777581	119	EXECUTED	9:502c557a5189f600f0f445a9b49ebbce	addColumn tableName=USER_ATTRIBUTE; addColumn tableName=FED_USER_ATTRIBUTE; createIndex indexName=USER_ATTR_LONG_VALUES, tableName=USER_ATTRIBUTE; createIndex indexName=FED_USER_ATTR_LONG_VALUES, tableName=FED_USER_ATTRIBUTE; createIndex indexName...		\N	4.25.1	\N	\N	9000128029
24.0.0-9758-2	keycloak	META-INF/jpa-changelog-24.0.0.xml	2026-01-21 12:55:33.788931	120	EXECUTED	9:bf0fdee10afdf597a987adbf291db7b2	customChange		\N	4.25.1	\N	\N	9000128029
24.0.0-26618-drop-index-if-present	keycloak	META-INF/jpa-changelog-24.0.0.xml	2026-01-21 12:55:33.809373	121	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	9000128029
24.0.0-26618-reindex	keycloak	META-INF/jpa-changelog-24.0.0.xml	2026-01-21 12:55:33.836006	122	EXECUTED	9:08707c0f0db1cef6b352db03a60edc7f	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	9000128029
24.0.2-27228	keycloak	META-INF/jpa-changelog-24.0.2.xml	2026-01-21 12:55:33.846924	123	EXECUTED	9:eaee11f6b8aa25d2cc6a84fb86fc6238	customChange		\N	4.25.1	\N	\N	9000128029
24.0.2-27967-drop-index-if-present	keycloak	META-INF/jpa-changelog-24.0.2.xml	2026-01-21 12:55:33.850355	124	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	9000128029
24.0.2-27967-reindex	keycloak	META-INF/jpa-changelog-24.0.2.xml	2026-01-21 12:55:33.85426	125	MARK_RAN	9:d3d977031d431db16e2c181ce49d73e9	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	9000128029
25.0.0-28265-tables	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-01-21 12:55:33.863277	126	EXECUTED	9:deda2df035df23388af95bbd36c17cef	addColumn tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_CLIENT_SESSION		\N	4.25.1	\N	\N	9000128029
25.0.0-28265-index-creation	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-01-21 12:55:33.874208	127	EXECUTED	9:3e96709818458ae49f3c679ae58d263a	createIndex indexName=IDX_OFFLINE_USS_BY_LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION		\N	4.25.1	\N	\N	9000128029
25.0.0-28265-index-cleanup	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-01-21 12:55:33.885499	128	EXECUTED	9:8c0cfa341a0474385b324f5c4b2dfcc1	dropIndex indexName=IDX_OFFLINE_USS_CREATEDON, tableName=OFFLINE_USER_SESSION; dropIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION; dropIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION; dropIndex ...		\N	4.25.1	\N	\N	9000128029
25.0.0-28265-index-2-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-01-21 12:55:33.889484	129	MARK_RAN	9:b7ef76036d3126bb83c2423bf4d449d6	createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION		\N	4.25.1	\N	\N	9000128029
25.0.0-28265-index-2-not-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-01-21 12:55:33.904642	130	EXECUTED	9:23396cf51ab8bc1ae6f0cac7f9f6fcf7	createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION		\N	4.25.1	\N	\N	9000128029
25.0.0-org	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-01-21 12:55:33.942895	131	EXECUTED	9:5c859965c2c9b9c72136c360649af157	createTable tableName=ORG; addUniqueConstraint constraintName=UK_ORG_NAME, tableName=ORG; addUniqueConstraint constraintName=UK_ORG_GROUP, tableName=ORG; createTable tableName=ORG_DOMAIN		\N	4.25.1	\N	\N	9000128029
unique-consentuser	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-01-21 12:55:33.97109	132	EXECUTED	9:5857626a2ea8767e9a6c66bf3a2cb32f	customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...		\N	4.25.1	\N	\N	9000128029
unique-consentuser-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-01-21 12:55:33.975153	133	MARK_RAN	9:b79478aad5adaa1bc428e31563f55e8e	customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...		\N	4.25.1	\N	\N	9000128029
25.0.0-28861-index-creation	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-01-21 12:55:33.997985	134	EXECUTED	9:b9acb58ac958d9ada0fe12a5d4794ab1	createIndex indexName=IDX_PERM_TICKET_REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; createIndex indexName=IDX_PERM_TICKET_OWNER, tableName=RESOURCE_SERVER_PERM_TICKET		\N	4.25.1	\N	\N	9000128029
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
1000	f	\N	\N
\.


--
-- Data for Name: default_client_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.default_client_scope (realm_id, scope_id, default_scope) FROM stdin;
e42af33c-a898-43d7-a74a-41752eb401e5	40e6df66-12f7-4aff-a410-6bcb10d74cbd	f
e42af33c-a898-43d7-a74a-41752eb401e5	ffb15e76-d900-4918-9924-e2232a833653	t
e42af33c-a898-43d7-a74a-41752eb401e5	1cc4ff81-e727-49a7-8578-918c15b75774	t
e42af33c-a898-43d7-a74a-41752eb401e5	7a90df18-5b0d-40b2-8eed-1c08190e59fb	t
e42af33c-a898-43d7-a74a-41752eb401e5	0fd26979-5fdf-4887-9a4f-bfdafafbc9df	f
e42af33c-a898-43d7-a74a-41752eb401e5	ca74dcc1-cf9a-4810-ae92-7d8c544d9265	f
e42af33c-a898-43d7-a74a-41752eb401e5	11767875-a413-4955-86fa-935c1029a643	t
e42af33c-a898-43d7-a74a-41752eb401e5	08d4cdd5-4c34-4eb0-8ea1-98255600e9ee	t
e42af33c-a898-43d7-a74a-41752eb401e5	28d8731d-c25a-4934-983f-d9280231cb87	f
e42af33c-a898-43d7-a74a-41752eb401e5	77b0de0b-7647-4818-ae87-890961805bea	t
e42af33c-a898-43d7-a74a-41752eb401e5	de935d50-e656-4360-ac35-10d839eb5901	t
513ce991-e46b-4e3b-a51e-c03c61f8f1ac	a265d52b-2a3c-4026-9e26-27fa4437a16b	f
513ce991-e46b-4e3b-a51e-c03c61f8f1ac	240442d3-6bd1-4476-b899-9b4f06a531a2	t
513ce991-e46b-4e3b-a51e-c03c61f8f1ac	d74d621e-c0cc-4348-9bfe-a180044541ac	t
513ce991-e46b-4e3b-a51e-c03c61f8f1ac	af40ed4f-96d1-4804-a958-5787f782374b	t
513ce991-e46b-4e3b-a51e-c03c61f8f1ac	521dda86-387d-40b2-b9cb-ff3005399375	f
513ce991-e46b-4e3b-a51e-c03c61f8f1ac	cdc36ae7-76ba-4648-a134-feb26af64e8a	f
513ce991-e46b-4e3b-a51e-c03c61f8f1ac	0faf676f-4fdd-482d-b927-741086d1ae8a	t
513ce991-e46b-4e3b-a51e-c03c61f8f1ac	87e8584f-0ca2-4baf-9a3b-f6b5a0240fef	t
513ce991-e46b-4e3b-a51e-c03c61f8f1ac	51e872f4-53ba-4277-8957-df35c1e73d9b	f
513ce991-e46b-4e3b-a51e-c03c61f8f1ac	67ab8409-5736-43d9-8730-8178653746ac	t
513ce991-e46b-4e3b-a51e-c03c61f8f1ac	d92045ce-c747-4e8a-a938-8c8093119274	t
\.


--
-- Data for Name: event_entity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.event_entity (id, client_id, details_json, error, ip_address, realm_id, session_id, event_time, type, user_id, details_json_long_value) FROM stdin;
\.


--
-- Data for Name: fed_user_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_attribute (id, name, user_id, realm_id, storage_provider_id, value, long_value_hash, long_value_hash_lower_case, long_value) FROM stdin;
\.


--
-- Data for Name: fed_user_consent; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_consent (id, client_id, user_id, realm_id, storage_provider_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: fed_user_consent_cl_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_consent_cl_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: fed_user_credential; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_credential (id, salt, type, created_date, user_id, realm_id, storage_provider_id, user_label, secret_data, credential_data, priority) FROM stdin;
\.


--
-- Data for Name: fed_user_group_membership; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_group_membership (group_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_required_action; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_required_action (required_action, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_role_mapping (role_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: federated_identity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.federated_identity (identity_provider, realm_id, federated_user_id, federated_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: federated_user; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.federated_user (id, storage_provider_id, realm_id) FROM stdin;
\.


--
-- Data for Name: group_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.group_attribute (id, name, value, group_id) FROM stdin;
\.


--
-- Data for Name: group_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.group_role_mapping (role_id, group_id) FROM stdin;
\.


--
-- Data for Name: identity_provider; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.identity_provider (internal_id, enabled, provider_alias, provider_id, store_token, authenticate_by_default, realm_id, add_token_role, trust_email, first_broker_login_flow_id, post_broker_login_flow_id, provider_display_name, link_only) FROM stdin;
\.


--
-- Data for Name: identity_provider_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.identity_provider_config (identity_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: identity_provider_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.identity_provider_mapper (id, name, idp_alias, idp_mapper_name, realm_id) FROM stdin;
\.


--
-- Data for Name: idp_mapper_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.idp_mapper_config (idp_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: keycloak_group; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.keycloak_group (id, name, parent_group, realm_id) FROM stdin;
\.


--
-- Data for Name: keycloak_role; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.keycloak_role (id, client_realm_constraint, client_role, description, name, realm_id, client, realm) FROM stdin;
c4ab8b5b-22ca-47f4-8d4e-9e923a0e0886	e42af33c-a898-43d7-a74a-41752eb401e5	f	${role_default-roles}	default-roles-master	e42af33c-a898-43d7-a74a-41752eb401e5	\N	\N
03bfbd42-710a-4214-a2da-e0e0d28b7604	e42af33c-a898-43d7-a74a-41752eb401e5	f	${role_create-realm}	create-realm	e42af33c-a898-43d7-a74a-41752eb401e5	\N	\N
a7988ea0-58e5-4014-ba01-9e3dcaf78161	e42af33c-a898-43d7-a74a-41752eb401e5	f	${role_admin}	admin	e42af33c-a898-43d7-a74a-41752eb401e5	\N	\N
748aee0a-37e4-49e6-b7a0-ac2e89121d07	04ef44ab-a9da-4f74-83cc-6286f9571307	t	${role_create-client}	create-client	e42af33c-a898-43d7-a74a-41752eb401e5	04ef44ab-a9da-4f74-83cc-6286f9571307	\N
716ea81b-112b-4141-8b3d-04d843df0785	04ef44ab-a9da-4f74-83cc-6286f9571307	t	${role_view-realm}	view-realm	e42af33c-a898-43d7-a74a-41752eb401e5	04ef44ab-a9da-4f74-83cc-6286f9571307	\N
54420468-3570-44bd-8e1b-4e96136d3a9e	04ef44ab-a9da-4f74-83cc-6286f9571307	t	${role_view-users}	view-users	e42af33c-a898-43d7-a74a-41752eb401e5	04ef44ab-a9da-4f74-83cc-6286f9571307	\N
c4d121d6-7f58-4e0d-856b-1347723a50d1	04ef44ab-a9da-4f74-83cc-6286f9571307	t	${role_view-clients}	view-clients	e42af33c-a898-43d7-a74a-41752eb401e5	04ef44ab-a9da-4f74-83cc-6286f9571307	\N
92497208-ec2f-43ae-b102-825e3ad78678	04ef44ab-a9da-4f74-83cc-6286f9571307	t	${role_view-events}	view-events	e42af33c-a898-43d7-a74a-41752eb401e5	04ef44ab-a9da-4f74-83cc-6286f9571307	\N
1422f84d-2652-4a81-81d2-b9f92a978f49	04ef44ab-a9da-4f74-83cc-6286f9571307	t	${role_view-identity-providers}	view-identity-providers	e42af33c-a898-43d7-a74a-41752eb401e5	04ef44ab-a9da-4f74-83cc-6286f9571307	\N
bc7b2873-6ddc-44c8-83f3-b71c81c86d21	04ef44ab-a9da-4f74-83cc-6286f9571307	t	${role_view-authorization}	view-authorization	e42af33c-a898-43d7-a74a-41752eb401e5	04ef44ab-a9da-4f74-83cc-6286f9571307	\N
39ddc1e2-cf07-4e15-afb6-e903979013f9	04ef44ab-a9da-4f74-83cc-6286f9571307	t	${role_manage-realm}	manage-realm	e42af33c-a898-43d7-a74a-41752eb401e5	04ef44ab-a9da-4f74-83cc-6286f9571307	\N
6a9888b9-f243-4409-a1df-6d6e66e8183a	04ef44ab-a9da-4f74-83cc-6286f9571307	t	${role_manage-users}	manage-users	e42af33c-a898-43d7-a74a-41752eb401e5	04ef44ab-a9da-4f74-83cc-6286f9571307	\N
da2c1f70-d601-4720-90b7-152421c4d8eb	04ef44ab-a9da-4f74-83cc-6286f9571307	t	${role_manage-clients}	manage-clients	e42af33c-a898-43d7-a74a-41752eb401e5	04ef44ab-a9da-4f74-83cc-6286f9571307	\N
51b39fba-ebd7-42ca-87b5-64549a9b5e4e	04ef44ab-a9da-4f74-83cc-6286f9571307	t	${role_manage-events}	manage-events	e42af33c-a898-43d7-a74a-41752eb401e5	04ef44ab-a9da-4f74-83cc-6286f9571307	\N
11e2f628-b435-494c-b2ea-019002734c3a	04ef44ab-a9da-4f74-83cc-6286f9571307	t	${role_manage-identity-providers}	manage-identity-providers	e42af33c-a898-43d7-a74a-41752eb401e5	04ef44ab-a9da-4f74-83cc-6286f9571307	\N
e23c5da1-eb3c-4bef-a209-749a26f72515	04ef44ab-a9da-4f74-83cc-6286f9571307	t	${role_manage-authorization}	manage-authorization	e42af33c-a898-43d7-a74a-41752eb401e5	04ef44ab-a9da-4f74-83cc-6286f9571307	\N
e39bf5a9-2627-4efa-9517-819daf44ea1d	04ef44ab-a9da-4f74-83cc-6286f9571307	t	${role_query-users}	query-users	e42af33c-a898-43d7-a74a-41752eb401e5	04ef44ab-a9da-4f74-83cc-6286f9571307	\N
b4260e76-3975-4428-986c-8271c2318cc7	04ef44ab-a9da-4f74-83cc-6286f9571307	t	${role_query-clients}	query-clients	e42af33c-a898-43d7-a74a-41752eb401e5	04ef44ab-a9da-4f74-83cc-6286f9571307	\N
5b109bf1-7465-40af-a8c8-79b315737adb	04ef44ab-a9da-4f74-83cc-6286f9571307	t	${role_query-realms}	query-realms	e42af33c-a898-43d7-a74a-41752eb401e5	04ef44ab-a9da-4f74-83cc-6286f9571307	\N
c660ea8d-97cf-49bf-9d79-f609d591029e	04ef44ab-a9da-4f74-83cc-6286f9571307	t	${role_query-groups}	query-groups	e42af33c-a898-43d7-a74a-41752eb401e5	04ef44ab-a9da-4f74-83cc-6286f9571307	\N
73e61119-7775-4dfa-a195-87633c8a26d6	9705949f-ee65-4669-ab9a-97d66354880f	t	${role_view-profile}	view-profile	e42af33c-a898-43d7-a74a-41752eb401e5	9705949f-ee65-4669-ab9a-97d66354880f	\N
7f5317c2-e0ea-49e2-b0d4-da9f46c90c79	9705949f-ee65-4669-ab9a-97d66354880f	t	${role_manage-account}	manage-account	e42af33c-a898-43d7-a74a-41752eb401e5	9705949f-ee65-4669-ab9a-97d66354880f	\N
357f28ed-4935-46c6-92bc-47cac12b2fc7	9705949f-ee65-4669-ab9a-97d66354880f	t	${role_manage-account-links}	manage-account-links	e42af33c-a898-43d7-a74a-41752eb401e5	9705949f-ee65-4669-ab9a-97d66354880f	\N
905eaae2-74c0-4cd8-aba1-cba456bc0adb	9705949f-ee65-4669-ab9a-97d66354880f	t	${role_view-applications}	view-applications	e42af33c-a898-43d7-a74a-41752eb401e5	9705949f-ee65-4669-ab9a-97d66354880f	\N
b8d2a41c-62dd-45d5-80d8-7e9b7db33b53	9705949f-ee65-4669-ab9a-97d66354880f	t	${role_view-consent}	view-consent	e42af33c-a898-43d7-a74a-41752eb401e5	9705949f-ee65-4669-ab9a-97d66354880f	\N
58b7d4d0-083e-4f43-a036-10bc4564d38a	9705949f-ee65-4669-ab9a-97d66354880f	t	${role_manage-consent}	manage-consent	e42af33c-a898-43d7-a74a-41752eb401e5	9705949f-ee65-4669-ab9a-97d66354880f	\N
1fd720d8-3eac-4b1c-b2ab-4abe8ac95dd6	9705949f-ee65-4669-ab9a-97d66354880f	t	${role_view-groups}	view-groups	e42af33c-a898-43d7-a74a-41752eb401e5	9705949f-ee65-4669-ab9a-97d66354880f	\N
5c1aa10a-8f65-4ae0-a3e0-924bf20926a2	9705949f-ee65-4669-ab9a-97d66354880f	t	${role_delete-account}	delete-account	e42af33c-a898-43d7-a74a-41752eb401e5	9705949f-ee65-4669-ab9a-97d66354880f	\N
42390c17-2fb2-4f33-8525-7efd9a2e37ff	55c810d6-12fb-4018-8b74-75c8f5805595	t	${role_read-token}	read-token	e42af33c-a898-43d7-a74a-41752eb401e5	55c810d6-12fb-4018-8b74-75c8f5805595	\N
dd641b8e-2cdb-440d-bc74-2f2f07c50d4b	04ef44ab-a9da-4f74-83cc-6286f9571307	t	${role_impersonation}	impersonation	e42af33c-a898-43d7-a74a-41752eb401e5	04ef44ab-a9da-4f74-83cc-6286f9571307	\N
ffeabf03-f75f-4f12-9956-5ad44f2015a5	e42af33c-a898-43d7-a74a-41752eb401e5	f	${role_offline-access}	offline_access	e42af33c-a898-43d7-a74a-41752eb401e5	\N	\N
092088a1-ad6c-49f1-adbe-48d051e9fced	e42af33c-a898-43d7-a74a-41752eb401e5	f	${role_uma_authorization}	uma_authorization	e42af33c-a898-43d7-a74a-41752eb401e5	\N	\N
855f5a56-1c23-4df8-acf5-12666652d32a	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	f	${role_default-roles}	default-roles-asrp	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	\N	\N
5d84b698-8653-4c2f-b584-4c4769beadef	c1bcfd99-f029-4775-9d65-0db353bbe973	t	${role_create-client}	create-client	e42af33c-a898-43d7-a74a-41752eb401e5	c1bcfd99-f029-4775-9d65-0db353bbe973	\N
5c52c3bd-8543-45d6-8678-0a516f3648d8	c1bcfd99-f029-4775-9d65-0db353bbe973	t	${role_view-realm}	view-realm	e42af33c-a898-43d7-a74a-41752eb401e5	c1bcfd99-f029-4775-9d65-0db353bbe973	\N
9a0714d0-6335-4a38-a1f4-41e6a048fb10	c1bcfd99-f029-4775-9d65-0db353bbe973	t	${role_view-users}	view-users	e42af33c-a898-43d7-a74a-41752eb401e5	c1bcfd99-f029-4775-9d65-0db353bbe973	\N
f62b4f23-106d-4308-b379-341a7a935479	c1bcfd99-f029-4775-9d65-0db353bbe973	t	${role_view-clients}	view-clients	e42af33c-a898-43d7-a74a-41752eb401e5	c1bcfd99-f029-4775-9d65-0db353bbe973	\N
b5b1bfb5-3dfc-46eb-87c4-7571f2487d3f	c1bcfd99-f029-4775-9d65-0db353bbe973	t	${role_view-events}	view-events	e42af33c-a898-43d7-a74a-41752eb401e5	c1bcfd99-f029-4775-9d65-0db353bbe973	\N
bc9c63e3-237d-4cf4-b986-2649fe494f85	c1bcfd99-f029-4775-9d65-0db353bbe973	t	${role_view-identity-providers}	view-identity-providers	e42af33c-a898-43d7-a74a-41752eb401e5	c1bcfd99-f029-4775-9d65-0db353bbe973	\N
7832bc2f-f015-4b0a-bf8b-0fa2900fae2e	c1bcfd99-f029-4775-9d65-0db353bbe973	t	${role_view-authorization}	view-authorization	e42af33c-a898-43d7-a74a-41752eb401e5	c1bcfd99-f029-4775-9d65-0db353bbe973	\N
3b3a69a2-c41c-4f67-bee8-1e381e76d29f	c1bcfd99-f029-4775-9d65-0db353bbe973	t	${role_manage-realm}	manage-realm	e42af33c-a898-43d7-a74a-41752eb401e5	c1bcfd99-f029-4775-9d65-0db353bbe973	\N
7d8d6529-0427-4625-b072-eb9616a4cb92	c1bcfd99-f029-4775-9d65-0db353bbe973	t	${role_manage-users}	manage-users	e42af33c-a898-43d7-a74a-41752eb401e5	c1bcfd99-f029-4775-9d65-0db353bbe973	\N
a9bdb46d-630f-4c3d-9151-f3340a19c6f6	c1bcfd99-f029-4775-9d65-0db353bbe973	t	${role_manage-clients}	manage-clients	e42af33c-a898-43d7-a74a-41752eb401e5	c1bcfd99-f029-4775-9d65-0db353bbe973	\N
4b3bf52c-36b7-40c2-a1fa-722ea9348816	c1bcfd99-f029-4775-9d65-0db353bbe973	t	${role_manage-events}	manage-events	e42af33c-a898-43d7-a74a-41752eb401e5	c1bcfd99-f029-4775-9d65-0db353bbe973	\N
bcc9c7a7-0bda-420a-9a3e-a0b4b22178fb	c1bcfd99-f029-4775-9d65-0db353bbe973	t	${role_manage-identity-providers}	manage-identity-providers	e42af33c-a898-43d7-a74a-41752eb401e5	c1bcfd99-f029-4775-9d65-0db353bbe973	\N
ccdb7f9f-0ab9-4bf1-840f-abe6de17ac0b	c1bcfd99-f029-4775-9d65-0db353bbe973	t	${role_manage-authorization}	manage-authorization	e42af33c-a898-43d7-a74a-41752eb401e5	c1bcfd99-f029-4775-9d65-0db353bbe973	\N
3eeb7f5a-ad7f-435a-8068-7c2e1a9c9da5	c1bcfd99-f029-4775-9d65-0db353bbe973	t	${role_query-users}	query-users	e42af33c-a898-43d7-a74a-41752eb401e5	c1bcfd99-f029-4775-9d65-0db353bbe973	\N
5fb773f4-bf08-4960-8cfc-1230dc13dbe7	c1bcfd99-f029-4775-9d65-0db353bbe973	t	${role_query-clients}	query-clients	e42af33c-a898-43d7-a74a-41752eb401e5	c1bcfd99-f029-4775-9d65-0db353bbe973	\N
9fbe85d4-c37d-499c-a5b6-e48cc99f7f4d	c1bcfd99-f029-4775-9d65-0db353bbe973	t	${role_query-realms}	query-realms	e42af33c-a898-43d7-a74a-41752eb401e5	c1bcfd99-f029-4775-9d65-0db353bbe973	\N
ea28bb81-98a2-470b-bffd-8a05a5013d49	c1bcfd99-f029-4775-9d65-0db353bbe973	t	${role_query-groups}	query-groups	e42af33c-a898-43d7-a74a-41752eb401e5	c1bcfd99-f029-4775-9d65-0db353bbe973	\N
f6bbe1c0-1e6f-4c19-b9bd-1ccb78ee5c04	29d23645-b92d-48dc-8015-8ad850505a65	t	${role_realm-admin}	realm-admin	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	29d23645-b92d-48dc-8015-8ad850505a65	\N
30b056c2-7164-477a-872d-011e4aa10719	29d23645-b92d-48dc-8015-8ad850505a65	t	${role_create-client}	create-client	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	29d23645-b92d-48dc-8015-8ad850505a65	\N
7c3c5bdf-0a75-4c4d-b3e9-4aa615aa6a60	29d23645-b92d-48dc-8015-8ad850505a65	t	${role_view-realm}	view-realm	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	29d23645-b92d-48dc-8015-8ad850505a65	\N
4e977c78-9179-4569-853f-341511678519	29d23645-b92d-48dc-8015-8ad850505a65	t	${role_view-users}	view-users	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	29d23645-b92d-48dc-8015-8ad850505a65	\N
ebc5b462-1142-45d2-b355-e8113cce880e	29d23645-b92d-48dc-8015-8ad850505a65	t	${role_view-clients}	view-clients	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	29d23645-b92d-48dc-8015-8ad850505a65	\N
e86af346-c1f6-4f9d-8dc3-95c66c87f213	29d23645-b92d-48dc-8015-8ad850505a65	t	${role_view-events}	view-events	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	29d23645-b92d-48dc-8015-8ad850505a65	\N
1a22f969-01a5-4cc2-816d-946157017a7c	29d23645-b92d-48dc-8015-8ad850505a65	t	${role_view-identity-providers}	view-identity-providers	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	29d23645-b92d-48dc-8015-8ad850505a65	\N
1a0f49dc-5cc2-40a2-b230-1553dc09b168	29d23645-b92d-48dc-8015-8ad850505a65	t	${role_view-authorization}	view-authorization	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	29d23645-b92d-48dc-8015-8ad850505a65	\N
62f26a8d-2cfe-4ad1-b45f-fc77b8e00f27	29d23645-b92d-48dc-8015-8ad850505a65	t	${role_manage-realm}	manage-realm	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	29d23645-b92d-48dc-8015-8ad850505a65	\N
acd2d9b6-f83e-4e71-a112-385c3219f30c	29d23645-b92d-48dc-8015-8ad850505a65	t	${role_manage-users}	manage-users	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	29d23645-b92d-48dc-8015-8ad850505a65	\N
7c3535c7-92d9-4abd-95ed-c965c9a5ec9e	29d23645-b92d-48dc-8015-8ad850505a65	t	${role_manage-clients}	manage-clients	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	29d23645-b92d-48dc-8015-8ad850505a65	\N
f18b3c93-17a1-4448-9b14-e5f0a6862e78	29d23645-b92d-48dc-8015-8ad850505a65	t	${role_manage-events}	manage-events	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	29d23645-b92d-48dc-8015-8ad850505a65	\N
3c2379b2-21ad-4c4a-a563-a6b75bf93c80	29d23645-b92d-48dc-8015-8ad850505a65	t	${role_manage-identity-providers}	manage-identity-providers	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	29d23645-b92d-48dc-8015-8ad850505a65	\N
fa1be923-657c-41e0-a2da-309e5c1737eb	29d23645-b92d-48dc-8015-8ad850505a65	t	${role_manage-authorization}	manage-authorization	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	29d23645-b92d-48dc-8015-8ad850505a65	\N
434682cf-3367-4b4c-b04c-d10ae080f9ce	29d23645-b92d-48dc-8015-8ad850505a65	t	${role_query-users}	query-users	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	29d23645-b92d-48dc-8015-8ad850505a65	\N
3be21d5b-2452-419c-a006-0c72af0e33e1	29d23645-b92d-48dc-8015-8ad850505a65	t	${role_query-clients}	query-clients	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	29d23645-b92d-48dc-8015-8ad850505a65	\N
610d1977-f547-48de-8df1-9c0e0db61ef7	29d23645-b92d-48dc-8015-8ad850505a65	t	${role_query-realms}	query-realms	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	29d23645-b92d-48dc-8015-8ad850505a65	\N
a42725fa-45c4-4948-aea0-0da8677fe928	29d23645-b92d-48dc-8015-8ad850505a65	t	${role_query-groups}	query-groups	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	29d23645-b92d-48dc-8015-8ad850505a65	\N
a1ae6eff-f867-48ae-8c48-6917681f9796	9d0d9417-47fb-45b2-a9c9-107809fcb94e	t	${role_view-profile}	view-profile	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	9d0d9417-47fb-45b2-a9c9-107809fcb94e	\N
3b70e7e8-f6c9-486a-b716-72c89734051b	9d0d9417-47fb-45b2-a9c9-107809fcb94e	t	${role_manage-account}	manage-account	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	9d0d9417-47fb-45b2-a9c9-107809fcb94e	\N
f480f9d5-8442-49e9-9107-82b0456d9590	9d0d9417-47fb-45b2-a9c9-107809fcb94e	t	${role_manage-account-links}	manage-account-links	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	9d0d9417-47fb-45b2-a9c9-107809fcb94e	\N
e42eb88b-050b-4582-ba1c-a1536cc44129	9d0d9417-47fb-45b2-a9c9-107809fcb94e	t	${role_view-applications}	view-applications	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	9d0d9417-47fb-45b2-a9c9-107809fcb94e	\N
92dc50b7-375c-4a01-901e-ed57a2cac550	9d0d9417-47fb-45b2-a9c9-107809fcb94e	t	${role_view-consent}	view-consent	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	9d0d9417-47fb-45b2-a9c9-107809fcb94e	\N
794a7a32-531c-446a-b545-acaddb40f390	9d0d9417-47fb-45b2-a9c9-107809fcb94e	t	${role_manage-consent}	manage-consent	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	9d0d9417-47fb-45b2-a9c9-107809fcb94e	\N
e0f5317f-4c91-4e41-a2c5-6414b6f1d943	9d0d9417-47fb-45b2-a9c9-107809fcb94e	t	${role_view-groups}	view-groups	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	9d0d9417-47fb-45b2-a9c9-107809fcb94e	\N
ff4792d7-bee4-4a31-9693-4fff98fc8bcf	9d0d9417-47fb-45b2-a9c9-107809fcb94e	t	${role_delete-account}	delete-account	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	9d0d9417-47fb-45b2-a9c9-107809fcb94e	\N
b88907a9-b924-4387-a887-c25bce875386	c1bcfd99-f029-4775-9d65-0db353bbe973	t	${role_impersonation}	impersonation	e42af33c-a898-43d7-a74a-41752eb401e5	c1bcfd99-f029-4775-9d65-0db353bbe973	\N
50ef8db0-dab0-4ef9-bab3-3d70f4f292cc	29d23645-b92d-48dc-8015-8ad850505a65	t	${role_impersonation}	impersonation	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	29d23645-b92d-48dc-8015-8ad850505a65	\N
a91e6fc1-a646-45ca-87e0-52971f1ae1e6	f82c753f-bbe2-4b40-a8ab-4b10a1d9001b	t	${role_read-token}	read-token	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	f82c753f-bbe2-4b40-a8ab-4b10a1d9001b	\N
ec4caaa0-1506-4e85-b8b0-f9968a13c874	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	f	${role_offline-access}	offline_access	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	\N	\N
5f8fe912-f5cc-43e6-902d-56e7db710d8b	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	f	${role_uma_authorization}	uma_authorization	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	\N	\N
f94a4e7f-ab6b-4764-ae8f-f5471ea1da8e	97153c86-824e-4ee5-999b-dc95800acaf8	t	Permiso de lectura	catalog_read	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	97153c86-824e-4ee5-999b-dc95800acaf8	\N
b3ff07b6-ce5b-4d99-a758-2bbf9f0e32fa	97153c86-824e-4ee5-999b-dc95800acaf8	t	Permisos de escritura	catalog_write	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	97153c86-824e-4ee5-999b-dc95800acaf8	\N
\.


--
-- Data for Name: migration_model; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.migration_model (id, version, update_time) FROM stdin;
p2s4e	25.0.6	1769000135
\.


--
-- Data for Name: offline_client_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.offline_client_session (user_session_id, client_id, offline_flag, "timestamp", data, client_storage_provider, external_client_id, version) FROM stdin;
\.


--
-- Data for Name: offline_user_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.offline_user_session (user_session_id, user_id, realm_id, created_on, offline_flag, data, last_session_refresh, broker_session_id, version) FROM stdin;
\.


--
-- Data for Name: org; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.org (id, enabled, realm_id, group_id, name, description) FROM stdin;
\.


--
-- Data for Name: org_domain; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.org_domain (id, name, verified, org_id) FROM stdin;
\.


--
-- Data for Name: policy_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.policy_config (policy_id, name, value) FROM stdin;
\.


--
-- Data for Name: protocol_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.protocol_mapper (id, name, protocol, protocol_mapper_name, client_id, client_scope_id) FROM stdin;
2bcf1549-f010-48ec-93e0-0d79b1284cec	audience resolve	openid-connect	oidc-audience-resolve-mapper	274c18c2-3acb-4828-8113-a49c994b9349	\N
116c697d-ddef-40ce-ac64-f82f6ba7b609	locale	openid-connect	oidc-usermodel-attribute-mapper	44a76799-b57d-49de-8ef7-a40f36e843c0	\N
8cfb67ca-a642-470d-9343-990c02f5b030	role list	saml	saml-role-list-mapper	\N	ffb15e76-d900-4918-9924-e2232a833653
0c735c0b-d540-4b3f-a594-db33fe693668	full name	openid-connect	oidc-full-name-mapper	\N	1cc4ff81-e727-49a7-8578-918c15b75774
f413163a-688a-4d20-905f-32229676b705	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	1cc4ff81-e727-49a7-8578-918c15b75774
7022db5d-ff34-4037-ba5d-35313123361e	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	1cc4ff81-e727-49a7-8578-918c15b75774
16a1bde3-d8b6-45e3-ade7-14c6108f97bd	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	1cc4ff81-e727-49a7-8578-918c15b75774
8a58cf7d-7027-4665-98aa-01760ffa8d6e	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	1cc4ff81-e727-49a7-8578-918c15b75774
d050c40d-9d56-489f-b0b6-92ccabafcac6	username	openid-connect	oidc-usermodel-attribute-mapper	\N	1cc4ff81-e727-49a7-8578-918c15b75774
f8f4c544-c634-42d2-877b-97b9d9a438f2	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	1cc4ff81-e727-49a7-8578-918c15b75774
d9e5b5d2-0f08-4937-823b-9bb7430779b5	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	1cc4ff81-e727-49a7-8578-918c15b75774
979d099c-7faf-4d81-8437-fa2475f00fb5	website	openid-connect	oidc-usermodel-attribute-mapper	\N	1cc4ff81-e727-49a7-8578-918c15b75774
b4c4d3dc-8fe7-47c4-891c-6c0719f57707	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	1cc4ff81-e727-49a7-8578-918c15b75774
6f786f65-e1b1-4c12-aa3d-8f18703ea0fb	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	1cc4ff81-e727-49a7-8578-918c15b75774
f85fc89f-569e-44bc-952c-45883d5d43f9	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	1cc4ff81-e727-49a7-8578-918c15b75774
d10a6171-dcff-441a-bbc2-9bf6c582fa7b	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	1cc4ff81-e727-49a7-8578-918c15b75774
2bbd05b8-57c9-44a3-a72d-70130532a3d5	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	1cc4ff81-e727-49a7-8578-918c15b75774
4e2ebb94-8e47-4337-bc9d-5cd9d662b94b	email	openid-connect	oidc-usermodel-attribute-mapper	\N	7a90df18-5b0d-40b2-8eed-1c08190e59fb
6deb4bf2-fa40-4663-9fe4-a9d663eb9ea2	email verified	openid-connect	oidc-usermodel-property-mapper	\N	7a90df18-5b0d-40b2-8eed-1c08190e59fb
4de5fc9d-6c78-483d-876e-31c37f6d7f0c	address	openid-connect	oidc-address-mapper	\N	0fd26979-5fdf-4887-9a4f-bfdafafbc9df
64a4e793-f7d6-4f89-a972-726b09e00756	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	ca74dcc1-cf9a-4810-ae92-7d8c544d9265
fbac9e00-74be-484e-9640-75cdc8236c7f	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	ca74dcc1-cf9a-4810-ae92-7d8c544d9265
02099209-a778-4fb7-9351-96bac0db4e24	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	11767875-a413-4955-86fa-935c1029a643
1b4d7dfc-9dd7-48d6-ad13-24578dcbc27b	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	11767875-a413-4955-86fa-935c1029a643
86f159b7-eaba-45d1-a9c6-b545d5d972c3	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	11767875-a413-4955-86fa-935c1029a643
efce0f47-fa43-47bc-8b7a-fc3f90d59775	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	08d4cdd5-4c34-4eb0-8ea1-98255600e9ee
c7bf651e-5620-492f-8a52-8c194285ffb3	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	28d8731d-c25a-4934-983f-d9280231cb87
9451053d-d783-4bbc-8250-93469e862fa1	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	28d8731d-c25a-4934-983f-d9280231cb87
46876c63-23bf-45d8-a35e-c17d68a8efa3	acr loa level	openid-connect	oidc-acr-mapper	\N	77b0de0b-7647-4818-ae87-890961805bea
9d3a43fa-bee8-479c-b3be-c449008be27d	auth_time	openid-connect	oidc-usersessionmodel-note-mapper	\N	de935d50-e656-4360-ac35-10d839eb5901
1ee47c23-3456-4e1e-982a-d80b8a776918	sub	openid-connect	oidc-sub-mapper	\N	de935d50-e656-4360-ac35-10d839eb5901
2a975419-8200-42ef-a624-489da2c6c497	audience resolve	openid-connect	oidc-audience-resolve-mapper	86d116d5-00ba-4976-b027-c2c46298f970	\N
239b54a4-03ed-44e3-aa1e-e0747afac776	role list	saml	saml-role-list-mapper	\N	240442d3-6bd1-4476-b899-9b4f06a531a2
088df05e-00bc-40ed-b06a-d1ee601ff651	full name	openid-connect	oidc-full-name-mapper	\N	d74d621e-c0cc-4348-9bfe-a180044541ac
483302bb-65cf-4a8c-a33e-7d677cfb22d8	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	d74d621e-c0cc-4348-9bfe-a180044541ac
f9eab602-840e-4682-b32c-b4c51877f39b	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	d74d621e-c0cc-4348-9bfe-a180044541ac
2443fd01-9eec-4239-8d6d-81dacb2e926c	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	d74d621e-c0cc-4348-9bfe-a180044541ac
5ae79779-9c67-46d4-b26f-e8411bbe81d4	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	d74d621e-c0cc-4348-9bfe-a180044541ac
d37de8a8-872b-4987-abf5-a28a78aac76c	username	openid-connect	oidc-usermodel-attribute-mapper	\N	d74d621e-c0cc-4348-9bfe-a180044541ac
8756086c-5fba-4737-811c-88e8cb1f2dd5	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	d74d621e-c0cc-4348-9bfe-a180044541ac
6cca0612-e214-4744-8062-b5882b41b800	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	d74d621e-c0cc-4348-9bfe-a180044541ac
2cd63242-9e0a-4a6a-8127-146dce386a45	website	openid-connect	oidc-usermodel-attribute-mapper	\N	d74d621e-c0cc-4348-9bfe-a180044541ac
47260c00-40d1-48e7-abf0-6dcdf2843082	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	d74d621e-c0cc-4348-9bfe-a180044541ac
6f781e21-e7f3-473e-bd4b-374b185fa11e	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	d74d621e-c0cc-4348-9bfe-a180044541ac
f8f73ae9-d13d-49e4-8e43-e5dfeaf8caea	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	d74d621e-c0cc-4348-9bfe-a180044541ac
4640abed-bf75-4e2f-ae93-8a0030f6634f	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	d74d621e-c0cc-4348-9bfe-a180044541ac
f241dfc6-b4d6-4b6c-8a2a-d805f2e0706e	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	d74d621e-c0cc-4348-9bfe-a180044541ac
a83f3ce3-e1f8-4002-9c90-ae6bd994e22c	email	openid-connect	oidc-usermodel-attribute-mapper	\N	af40ed4f-96d1-4804-a958-5787f782374b
71025fbb-a969-4ed8-bb7b-edaee40adfc6	email verified	openid-connect	oidc-usermodel-property-mapper	\N	af40ed4f-96d1-4804-a958-5787f782374b
8c8bf779-4e46-4747-bd7d-54acf7243a45	address	openid-connect	oidc-address-mapper	\N	521dda86-387d-40b2-b9cb-ff3005399375
b2edd8cf-d274-45a2-8d7d-69d63ade9e84	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	cdc36ae7-76ba-4648-a134-feb26af64e8a
2add61d5-d1cc-4767-a0f8-2fe6a4cba596	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	cdc36ae7-76ba-4648-a134-feb26af64e8a
f4f13ffa-5345-42f3-bea7-9264a33a5406	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	0faf676f-4fdd-482d-b927-741086d1ae8a
edc812b8-e0d7-40aa-8eb9-bc4619cee6f7	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	0faf676f-4fdd-482d-b927-741086d1ae8a
372ae9a6-bce0-451a-99e7-19b596e93dd3	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	0faf676f-4fdd-482d-b927-741086d1ae8a
f423d814-5b05-4b16-9cc9-dffe6f4047cc	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	87e8584f-0ca2-4baf-9a3b-f6b5a0240fef
f4a574b5-4595-4166-84a6-bd9f27ca75ed	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	51e872f4-53ba-4277-8957-df35c1e73d9b
9f0f7cb7-4ea9-4d7b-8f41-ab60377c6596	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	51e872f4-53ba-4277-8957-df35c1e73d9b
234f3067-4f1e-4c63-9947-45097e7ef911	acr loa level	openid-connect	oidc-acr-mapper	\N	67ab8409-5736-43d9-8730-8178653746ac
47699d9c-5d73-45c3-9fc9-167dacb69a5e	auth_time	openid-connect	oidc-usersessionmodel-note-mapper	\N	d92045ce-c747-4e8a-a938-8c8093119274
b2fad6e4-d8fb-42bc-b586-d60012b0a13d	sub	openid-connect	oidc-sub-mapper	\N	d92045ce-c747-4e8a-a938-8c8093119274
c5370c67-8bc9-4e55-9c6c-1e55dd0e9963	locale	openid-connect	oidc-usermodel-attribute-mapper	215d5479-a28b-480f-88a4-d119a2ed849a	\N
0bb96502-6796-47c7-a7f6-fb66e6935195	audience-asrp-catalog	openid-connect	oidc-audience-mapper	97153c86-824e-4ee5-999b-dc95800acaf8	\N
\.


--
-- Data for Name: protocol_mapper_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.protocol_mapper_config (protocol_mapper_id, value, name) FROM stdin;
116c697d-ddef-40ce-ac64-f82f6ba7b609	true	introspection.token.claim
116c697d-ddef-40ce-ac64-f82f6ba7b609	true	userinfo.token.claim
116c697d-ddef-40ce-ac64-f82f6ba7b609	locale	user.attribute
116c697d-ddef-40ce-ac64-f82f6ba7b609	true	id.token.claim
116c697d-ddef-40ce-ac64-f82f6ba7b609	true	access.token.claim
116c697d-ddef-40ce-ac64-f82f6ba7b609	locale	claim.name
116c697d-ddef-40ce-ac64-f82f6ba7b609	String	jsonType.label
8cfb67ca-a642-470d-9343-990c02f5b030	false	single
8cfb67ca-a642-470d-9343-990c02f5b030	Basic	attribute.nameformat
8cfb67ca-a642-470d-9343-990c02f5b030	Role	attribute.name
0c735c0b-d540-4b3f-a594-db33fe693668	true	introspection.token.claim
0c735c0b-d540-4b3f-a594-db33fe693668	true	userinfo.token.claim
0c735c0b-d540-4b3f-a594-db33fe693668	true	id.token.claim
0c735c0b-d540-4b3f-a594-db33fe693668	true	access.token.claim
16a1bde3-d8b6-45e3-ade7-14c6108f97bd	true	introspection.token.claim
16a1bde3-d8b6-45e3-ade7-14c6108f97bd	true	userinfo.token.claim
16a1bde3-d8b6-45e3-ade7-14c6108f97bd	middleName	user.attribute
16a1bde3-d8b6-45e3-ade7-14c6108f97bd	true	id.token.claim
16a1bde3-d8b6-45e3-ade7-14c6108f97bd	true	access.token.claim
16a1bde3-d8b6-45e3-ade7-14c6108f97bd	middle_name	claim.name
16a1bde3-d8b6-45e3-ade7-14c6108f97bd	String	jsonType.label
2bbd05b8-57c9-44a3-a72d-70130532a3d5	true	introspection.token.claim
2bbd05b8-57c9-44a3-a72d-70130532a3d5	true	userinfo.token.claim
2bbd05b8-57c9-44a3-a72d-70130532a3d5	updatedAt	user.attribute
2bbd05b8-57c9-44a3-a72d-70130532a3d5	true	id.token.claim
2bbd05b8-57c9-44a3-a72d-70130532a3d5	true	access.token.claim
2bbd05b8-57c9-44a3-a72d-70130532a3d5	updated_at	claim.name
2bbd05b8-57c9-44a3-a72d-70130532a3d5	long	jsonType.label
6f786f65-e1b1-4c12-aa3d-8f18703ea0fb	true	introspection.token.claim
6f786f65-e1b1-4c12-aa3d-8f18703ea0fb	true	userinfo.token.claim
6f786f65-e1b1-4c12-aa3d-8f18703ea0fb	birthdate	user.attribute
6f786f65-e1b1-4c12-aa3d-8f18703ea0fb	true	id.token.claim
6f786f65-e1b1-4c12-aa3d-8f18703ea0fb	true	access.token.claim
6f786f65-e1b1-4c12-aa3d-8f18703ea0fb	birthdate	claim.name
6f786f65-e1b1-4c12-aa3d-8f18703ea0fb	String	jsonType.label
7022db5d-ff34-4037-ba5d-35313123361e	true	introspection.token.claim
7022db5d-ff34-4037-ba5d-35313123361e	true	userinfo.token.claim
7022db5d-ff34-4037-ba5d-35313123361e	firstName	user.attribute
7022db5d-ff34-4037-ba5d-35313123361e	true	id.token.claim
7022db5d-ff34-4037-ba5d-35313123361e	true	access.token.claim
7022db5d-ff34-4037-ba5d-35313123361e	given_name	claim.name
7022db5d-ff34-4037-ba5d-35313123361e	String	jsonType.label
8a58cf7d-7027-4665-98aa-01760ffa8d6e	true	introspection.token.claim
8a58cf7d-7027-4665-98aa-01760ffa8d6e	true	userinfo.token.claim
8a58cf7d-7027-4665-98aa-01760ffa8d6e	nickname	user.attribute
8a58cf7d-7027-4665-98aa-01760ffa8d6e	true	id.token.claim
8a58cf7d-7027-4665-98aa-01760ffa8d6e	true	access.token.claim
8a58cf7d-7027-4665-98aa-01760ffa8d6e	nickname	claim.name
8a58cf7d-7027-4665-98aa-01760ffa8d6e	String	jsonType.label
979d099c-7faf-4d81-8437-fa2475f00fb5	true	introspection.token.claim
979d099c-7faf-4d81-8437-fa2475f00fb5	true	userinfo.token.claim
979d099c-7faf-4d81-8437-fa2475f00fb5	website	user.attribute
979d099c-7faf-4d81-8437-fa2475f00fb5	true	id.token.claim
979d099c-7faf-4d81-8437-fa2475f00fb5	true	access.token.claim
979d099c-7faf-4d81-8437-fa2475f00fb5	website	claim.name
979d099c-7faf-4d81-8437-fa2475f00fb5	String	jsonType.label
b4c4d3dc-8fe7-47c4-891c-6c0719f57707	true	introspection.token.claim
b4c4d3dc-8fe7-47c4-891c-6c0719f57707	true	userinfo.token.claim
b4c4d3dc-8fe7-47c4-891c-6c0719f57707	gender	user.attribute
b4c4d3dc-8fe7-47c4-891c-6c0719f57707	true	id.token.claim
b4c4d3dc-8fe7-47c4-891c-6c0719f57707	true	access.token.claim
b4c4d3dc-8fe7-47c4-891c-6c0719f57707	gender	claim.name
b4c4d3dc-8fe7-47c4-891c-6c0719f57707	String	jsonType.label
d050c40d-9d56-489f-b0b6-92ccabafcac6	true	introspection.token.claim
d050c40d-9d56-489f-b0b6-92ccabafcac6	true	userinfo.token.claim
d050c40d-9d56-489f-b0b6-92ccabafcac6	username	user.attribute
d050c40d-9d56-489f-b0b6-92ccabafcac6	true	id.token.claim
d050c40d-9d56-489f-b0b6-92ccabafcac6	true	access.token.claim
d050c40d-9d56-489f-b0b6-92ccabafcac6	preferred_username	claim.name
d050c40d-9d56-489f-b0b6-92ccabafcac6	String	jsonType.label
d10a6171-dcff-441a-bbc2-9bf6c582fa7b	true	introspection.token.claim
d10a6171-dcff-441a-bbc2-9bf6c582fa7b	true	userinfo.token.claim
d10a6171-dcff-441a-bbc2-9bf6c582fa7b	locale	user.attribute
d10a6171-dcff-441a-bbc2-9bf6c582fa7b	true	id.token.claim
d10a6171-dcff-441a-bbc2-9bf6c582fa7b	true	access.token.claim
d10a6171-dcff-441a-bbc2-9bf6c582fa7b	locale	claim.name
d10a6171-dcff-441a-bbc2-9bf6c582fa7b	String	jsonType.label
d9e5b5d2-0f08-4937-823b-9bb7430779b5	true	introspection.token.claim
d9e5b5d2-0f08-4937-823b-9bb7430779b5	true	userinfo.token.claim
d9e5b5d2-0f08-4937-823b-9bb7430779b5	picture	user.attribute
d9e5b5d2-0f08-4937-823b-9bb7430779b5	true	id.token.claim
d9e5b5d2-0f08-4937-823b-9bb7430779b5	true	access.token.claim
d9e5b5d2-0f08-4937-823b-9bb7430779b5	picture	claim.name
d9e5b5d2-0f08-4937-823b-9bb7430779b5	String	jsonType.label
f413163a-688a-4d20-905f-32229676b705	true	introspection.token.claim
f413163a-688a-4d20-905f-32229676b705	true	userinfo.token.claim
f413163a-688a-4d20-905f-32229676b705	lastName	user.attribute
f413163a-688a-4d20-905f-32229676b705	true	id.token.claim
f413163a-688a-4d20-905f-32229676b705	true	access.token.claim
f413163a-688a-4d20-905f-32229676b705	family_name	claim.name
f413163a-688a-4d20-905f-32229676b705	String	jsonType.label
f85fc89f-569e-44bc-952c-45883d5d43f9	true	introspection.token.claim
f85fc89f-569e-44bc-952c-45883d5d43f9	true	userinfo.token.claim
f85fc89f-569e-44bc-952c-45883d5d43f9	zoneinfo	user.attribute
f85fc89f-569e-44bc-952c-45883d5d43f9	true	id.token.claim
f85fc89f-569e-44bc-952c-45883d5d43f9	true	access.token.claim
f85fc89f-569e-44bc-952c-45883d5d43f9	zoneinfo	claim.name
f85fc89f-569e-44bc-952c-45883d5d43f9	String	jsonType.label
f8f4c544-c634-42d2-877b-97b9d9a438f2	true	introspection.token.claim
f8f4c544-c634-42d2-877b-97b9d9a438f2	true	userinfo.token.claim
f8f4c544-c634-42d2-877b-97b9d9a438f2	profile	user.attribute
f8f4c544-c634-42d2-877b-97b9d9a438f2	true	id.token.claim
f8f4c544-c634-42d2-877b-97b9d9a438f2	true	access.token.claim
f8f4c544-c634-42d2-877b-97b9d9a438f2	profile	claim.name
f8f4c544-c634-42d2-877b-97b9d9a438f2	String	jsonType.label
4e2ebb94-8e47-4337-bc9d-5cd9d662b94b	true	introspection.token.claim
4e2ebb94-8e47-4337-bc9d-5cd9d662b94b	true	userinfo.token.claim
4e2ebb94-8e47-4337-bc9d-5cd9d662b94b	email	user.attribute
4e2ebb94-8e47-4337-bc9d-5cd9d662b94b	true	id.token.claim
4e2ebb94-8e47-4337-bc9d-5cd9d662b94b	true	access.token.claim
4e2ebb94-8e47-4337-bc9d-5cd9d662b94b	email	claim.name
4e2ebb94-8e47-4337-bc9d-5cd9d662b94b	String	jsonType.label
6deb4bf2-fa40-4663-9fe4-a9d663eb9ea2	true	introspection.token.claim
6deb4bf2-fa40-4663-9fe4-a9d663eb9ea2	true	userinfo.token.claim
6deb4bf2-fa40-4663-9fe4-a9d663eb9ea2	emailVerified	user.attribute
6deb4bf2-fa40-4663-9fe4-a9d663eb9ea2	true	id.token.claim
6deb4bf2-fa40-4663-9fe4-a9d663eb9ea2	true	access.token.claim
6deb4bf2-fa40-4663-9fe4-a9d663eb9ea2	email_verified	claim.name
6deb4bf2-fa40-4663-9fe4-a9d663eb9ea2	boolean	jsonType.label
4de5fc9d-6c78-483d-876e-31c37f6d7f0c	formatted	user.attribute.formatted
4de5fc9d-6c78-483d-876e-31c37f6d7f0c	country	user.attribute.country
4de5fc9d-6c78-483d-876e-31c37f6d7f0c	true	introspection.token.claim
4de5fc9d-6c78-483d-876e-31c37f6d7f0c	postal_code	user.attribute.postal_code
4de5fc9d-6c78-483d-876e-31c37f6d7f0c	true	userinfo.token.claim
4de5fc9d-6c78-483d-876e-31c37f6d7f0c	street	user.attribute.street
4de5fc9d-6c78-483d-876e-31c37f6d7f0c	true	id.token.claim
4de5fc9d-6c78-483d-876e-31c37f6d7f0c	region	user.attribute.region
4de5fc9d-6c78-483d-876e-31c37f6d7f0c	true	access.token.claim
4de5fc9d-6c78-483d-876e-31c37f6d7f0c	locality	user.attribute.locality
64a4e793-f7d6-4f89-a972-726b09e00756	true	introspection.token.claim
64a4e793-f7d6-4f89-a972-726b09e00756	true	userinfo.token.claim
64a4e793-f7d6-4f89-a972-726b09e00756	phoneNumber	user.attribute
64a4e793-f7d6-4f89-a972-726b09e00756	true	id.token.claim
64a4e793-f7d6-4f89-a972-726b09e00756	true	access.token.claim
64a4e793-f7d6-4f89-a972-726b09e00756	phone_number	claim.name
64a4e793-f7d6-4f89-a972-726b09e00756	String	jsonType.label
fbac9e00-74be-484e-9640-75cdc8236c7f	true	introspection.token.claim
fbac9e00-74be-484e-9640-75cdc8236c7f	true	userinfo.token.claim
fbac9e00-74be-484e-9640-75cdc8236c7f	phoneNumberVerified	user.attribute
fbac9e00-74be-484e-9640-75cdc8236c7f	true	id.token.claim
fbac9e00-74be-484e-9640-75cdc8236c7f	true	access.token.claim
fbac9e00-74be-484e-9640-75cdc8236c7f	phone_number_verified	claim.name
fbac9e00-74be-484e-9640-75cdc8236c7f	boolean	jsonType.label
02099209-a778-4fb7-9351-96bac0db4e24	true	introspection.token.claim
02099209-a778-4fb7-9351-96bac0db4e24	true	multivalued
02099209-a778-4fb7-9351-96bac0db4e24	foo	user.attribute
02099209-a778-4fb7-9351-96bac0db4e24	true	access.token.claim
02099209-a778-4fb7-9351-96bac0db4e24	realm_access.roles	claim.name
02099209-a778-4fb7-9351-96bac0db4e24	String	jsonType.label
1b4d7dfc-9dd7-48d6-ad13-24578dcbc27b	true	introspection.token.claim
1b4d7dfc-9dd7-48d6-ad13-24578dcbc27b	true	multivalued
1b4d7dfc-9dd7-48d6-ad13-24578dcbc27b	foo	user.attribute
1b4d7dfc-9dd7-48d6-ad13-24578dcbc27b	true	access.token.claim
1b4d7dfc-9dd7-48d6-ad13-24578dcbc27b	resource_access.${client_id}.roles	claim.name
1b4d7dfc-9dd7-48d6-ad13-24578dcbc27b	String	jsonType.label
86f159b7-eaba-45d1-a9c6-b545d5d972c3	true	introspection.token.claim
86f159b7-eaba-45d1-a9c6-b545d5d972c3	true	access.token.claim
efce0f47-fa43-47bc-8b7a-fc3f90d59775	true	introspection.token.claim
efce0f47-fa43-47bc-8b7a-fc3f90d59775	true	access.token.claim
9451053d-d783-4bbc-8250-93469e862fa1	true	introspection.token.claim
9451053d-d783-4bbc-8250-93469e862fa1	true	multivalued
9451053d-d783-4bbc-8250-93469e862fa1	foo	user.attribute
9451053d-d783-4bbc-8250-93469e862fa1	true	id.token.claim
9451053d-d783-4bbc-8250-93469e862fa1	true	access.token.claim
9451053d-d783-4bbc-8250-93469e862fa1	groups	claim.name
9451053d-d783-4bbc-8250-93469e862fa1	String	jsonType.label
c7bf651e-5620-492f-8a52-8c194285ffb3	true	introspection.token.claim
c7bf651e-5620-492f-8a52-8c194285ffb3	true	userinfo.token.claim
c7bf651e-5620-492f-8a52-8c194285ffb3	username	user.attribute
c7bf651e-5620-492f-8a52-8c194285ffb3	true	id.token.claim
c7bf651e-5620-492f-8a52-8c194285ffb3	true	access.token.claim
c7bf651e-5620-492f-8a52-8c194285ffb3	upn	claim.name
c7bf651e-5620-492f-8a52-8c194285ffb3	String	jsonType.label
46876c63-23bf-45d8-a35e-c17d68a8efa3	true	introspection.token.claim
46876c63-23bf-45d8-a35e-c17d68a8efa3	true	id.token.claim
46876c63-23bf-45d8-a35e-c17d68a8efa3	true	access.token.claim
1ee47c23-3456-4e1e-982a-d80b8a776918	true	introspection.token.claim
1ee47c23-3456-4e1e-982a-d80b8a776918	true	access.token.claim
9d3a43fa-bee8-479c-b3be-c449008be27d	AUTH_TIME	user.session.note
9d3a43fa-bee8-479c-b3be-c449008be27d	true	introspection.token.claim
9d3a43fa-bee8-479c-b3be-c449008be27d	true	id.token.claim
9d3a43fa-bee8-479c-b3be-c449008be27d	true	access.token.claim
9d3a43fa-bee8-479c-b3be-c449008be27d	auth_time	claim.name
9d3a43fa-bee8-479c-b3be-c449008be27d	long	jsonType.label
239b54a4-03ed-44e3-aa1e-e0747afac776	false	single
239b54a4-03ed-44e3-aa1e-e0747afac776	Basic	attribute.nameformat
239b54a4-03ed-44e3-aa1e-e0747afac776	Role	attribute.name
088df05e-00bc-40ed-b06a-d1ee601ff651	true	introspection.token.claim
088df05e-00bc-40ed-b06a-d1ee601ff651	true	userinfo.token.claim
088df05e-00bc-40ed-b06a-d1ee601ff651	true	id.token.claim
088df05e-00bc-40ed-b06a-d1ee601ff651	true	access.token.claim
2443fd01-9eec-4239-8d6d-81dacb2e926c	true	introspection.token.claim
2443fd01-9eec-4239-8d6d-81dacb2e926c	true	userinfo.token.claim
2443fd01-9eec-4239-8d6d-81dacb2e926c	middleName	user.attribute
2443fd01-9eec-4239-8d6d-81dacb2e926c	true	id.token.claim
2443fd01-9eec-4239-8d6d-81dacb2e926c	true	access.token.claim
2443fd01-9eec-4239-8d6d-81dacb2e926c	middle_name	claim.name
2443fd01-9eec-4239-8d6d-81dacb2e926c	String	jsonType.label
2cd63242-9e0a-4a6a-8127-146dce386a45	true	introspection.token.claim
2cd63242-9e0a-4a6a-8127-146dce386a45	true	userinfo.token.claim
2cd63242-9e0a-4a6a-8127-146dce386a45	website	user.attribute
2cd63242-9e0a-4a6a-8127-146dce386a45	true	id.token.claim
2cd63242-9e0a-4a6a-8127-146dce386a45	true	access.token.claim
2cd63242-9e0a-4a6a-8127-146dce386a45	website	claim.name
2cd63242-9e0a-4a6a-8127-146dce386a45	String	jsonType.label
4640abed-bf75-4e2f-ae93-8a0030f6634f	true	introspection.token.claim
4640abed-bf75-4e2f-ae93-8a0030f6634f	true	userinfo.token.claim
4640abed-bf75-4e2f-ae93-8a0030f6634f	locale	user.attribute
4640abed-bf75-4e2f-ae93-8a0030f6634f	true	id.token.claim
4640abed-bf75-4e2f-ae93-8a0030f6634f	true	access.token.claim
4640abed-bf75-4e2f-ae93-8a0030f6634f	locale	claim.name
4640abed-bf75-4e2f-ae93-8a0030f6634f	String	jsonType.label
47260c00-40d1-48e7-abf0-6dcdf2843082	true	introspection.token.claim
47260c00-40d1-48e7-abf0-6dcdf2843082	true	userinfo.token.claim
47260c00-40d1-48e7-abf0-6dcdf2843082	gender	user.attribute
47260c00-40d1-48e7-abf0-6dcdf2843082	true	id.token.claim
47260c00-40d1-48e7-abf0-6dcdf2843082	true	access.token.claim
47260c00-40d1-48e7-abf0-6dcdf2843082	gender	claim.name
47260c00-40d1-48e7-abf0-6dcdf2843082	String	jsonType.label
483302bb-65cf-4a8c-a33e-7d677cfb22d8	true	introspection.token.claim
483302bb-65cf-4a8c-a33e-7d677cfb22d8	true	userinfo.token.claim
483302bb-65cf-4a8c-a33e-7d677cfb22d8	lastName	user.attribute
483302bb-65cf-4a8c-a33e-7d677cfb22d8	true	id.token.claim
483302bb-65cf-4a8c-a33e-7d677cfb22d8	true	access.token.claim
483302bb-65cf-4a8c-a33e-7d677cfb22d8	family_name	claim.name
483302bb-65cf-4a8c-a33e-7d677cfb22d8	String	jsonType.label
5ae79779-9c67-46d4-b26f-e8411bbe81d4	true	introspection.token.claim
5ae79779-9c67-46d4-b26f-e8411bbe81d4	true	userinfo.token.claim
5ae79779-9c67-46d4-b26f-e8411bbe81d4	nickname	user.attribute
5ae79779-9c67-46d4-b26f-e8411bbe81d4	true	id.token.claim
5ae79779-9c67-46d4-b26f-e8411bbe81d4	true	access.token.claim
5ae79779-9c67-46d4-b26f-e8411bbe81d4	nickname	claim.name
5ae79779-9c67-46d4-b26f-e8411bbe81d4	String	jsonType.label
6cca0612-e214-4744-8062-b5882b41b800	true	introspection.token.claim
6cca0612-e214-4744-8062-b5882b41b800	true	userinfo.token.claim
6cca0612-e214-4744-8062-b5882b41b800	picture	user.attribute
6cca0612-e214-4744-8062-b5882b41b800	true	id.token.claim
6cca0612-e214-4744-8062-b5882b41b800	true	access.token.claim
6cca0612-e214-4744-8062-b5882b41b800	picture	claim.name
6cca0612-e214-4744-8062-b5882b41b800	String	jsonType.label
6f781e21-e7f3-473e-bd4b-374b185fa11e	true	introspection.token.claim
6f781e21-e7f3-473e-bd4b-374b185fa11e	true	userinfo.token.claim
6f781e21-e7f3-473e-bd4b-374b185fa11e	birthdate	user.attribute
6f781e21-e7f3-473e-bd4b-374b185fa11e	true	id.token.claim
6f781e21-e7f3-473e-bd4b-374b185fa11e	true	access.token.claim
6f781e21-e7f3-473e-bd4b-374b185fa11e	birthdate	claim.name
6f781e21-e7f3-473e-bd4b-374b185fa11e	String	jsonType.label
8756086c-5fba-4737-811c-88e8cb1f2dd5	true	introspection.token.claim
8756086c-5fba-4737-811c-88e8cb1f2dd5	true	userinfo.token.claim
8756086c-5fba-4737-811c-88e8cb1f2dd5	profile	user.attribute
8756086c-5fba-4737-811c-88e8cb1f2dd5	true	id.token.claim
8756086c-5fba-4737-811c-88e8cb1f2dd5	true	access.token.claim
8756086c-5fba-4737-811c-88e8cb1f2dd5	profile	claim.name
8756086c-5fba-4737-811c-88e8cb1f2dd5	String	jsonType.label
d37de8a8-872b-4987-abf5-a28a78aac76c	true	introspection.token.claim
d37de8a8-872b-4987-abf5-a28a78aac76c	true	userinfo.token.claim
d37de8a8-872b-4987-abf5-a28a78aac76c	username	user.attribute
d37de8a8-872b-4987-abf5-a28a78aac76c	true	id.token.claim
d37de8a8-872b-4987-abf5-a28a78aac76c	true	access.token.claim
d37de8a8-872b-4987-abf5-a28a78aac76c	preferred_username	claim.name
d37de8a8-872b-4987-abf5-a28a78aac76c	String	jsonType.label
f241dfc6-b4d6-4b6c-8a2a-d805f2e0706e	true	introspection.token.claim
f241dfc6-b4d6-4b6c-8a2a-d805f2e0706e	true	userinfo.token.claim
f241dfc6-b4d6-4b6c-8a2a-d805f2e0706e	updatedAt	user.attribute
f241dfc6-b4d6-4b6c-8a2a-d805f2e0706e	true	id.token.claim
f241dfc6-b4d6-4b6c-8a2a-d805f2e0706e	true	access.token.claim
f241dfc6-b4d6-4b6c-8a2a-d805f2e0706e	updated_at	claim.name
f241dfc6-b4d6-4b6c-8a2a-d805f2e0706e	long	jsonType.label
f8f73ae9-d13d-49e4-8e43-e5dfeaf8caea	true	introspection.token.claim
f8f73ae9-d13d-49e4-8e43-e5dfeaf8caea	true	userinfo.token.claim
f8f73ae9-d13d-49e4-8e43-e5dfeaf8caea	zoneinfo	user.attribute
f8f73ae9-d13d-49e4-8e43-e5dfeaf8caea	true	id.token.claim
f8f73ae9-d13d-49e4-8e43-e5dfeaf8caea	true	access.token.claim
f8f73ae9-d13d-49e4-8e43-e5dfeaf8caea	zoneinfo	claim.name
f8f73ae9-d13d-49e4-8e43-e5dfeaf8caea	String	jsonType.label
f9eab602-840e-4682-b32c-b4c51877f39b	true	introspection.token.claim
f9eab602-840e-4682-b32c-b4c51877f39b	true	userinfo.token.claim
f9eab602-840e-4682-b32c-b4c51877f39b	firstName	user.attribute
f9eab602-840e-4682-b32c-b4c51877f39b	true	id.token.claim
f9eab602-840e-4682-b32c-b4c51877f39b	true	access.token.claim
f9eab602-840e-4682-b32c-b4c51877f39b	given_name	claim.name
f9eab602-840e-4682-b32c-b4c51877f39b	String	jsonType.label
71025fbb-a969-4ed8-bb7b-edaee40adfc6	true	introspection.token.claim
71025fbb-a969-4ed8-bb7b-edaee40adfc6	true	userinfo.token.claim
71025fbb-a969-4ed8-bb7b-edaee40adfc6	emailVerified	user.attribute
71025fbb-a969-4ed8-bb7b-edaee40adfc6	true	id.token.claim
71025fbb-a969-4ed8-bb7b-edaee40adfc6	true	access.token.claim
71025fbb-a969-4ed8-bb7b-edaee40adfc6	email_verified	claim.name
71025fbb-a969-4ed8-bb7b-edaee40adfc6	boolean	jsonType.label
a83f3ce3-e1f8-4002-9c90-ae6bd994e22c	true	introspection.token.claim
a83f3ce3-e1f8-4002-9c90-ae6bd994e22c	true	userinfo.token.claim
a83f3ce3-e1f8-4002-9c90-ae6bd994e22c	email	user.attribute
a83f3ce3-e1f8-4002-9c90-ae6bd994e22c	true	id.token.claim
a83f3ce3-e1f8-4002-9c90-ae6bd994e22c	true	access.token.claim
a83f3ce3-e1f8-4002-9c90-ae6bd994e22c	email	claim.name
a83f3ce3-e1f8-4002-9c90-ae6bd994e22c	String	jsonType.label
8c8bf779-4e46-4747-bd7d-54acf7243a45	formatted	user.attribute.formatted
8c8bf779-4e46-4747-bd7d-54acf7243a45	country	user.attribute.country
8c8bf779-4e46-4747-bd7d-54acf7243a45	true	introspection.token.claim
8c8bf779-4e46-4747-bd7d-54acf7243a45	postal_code	user.attribute.postal_code
8c8bf779-4e46-4747-bd7d-54acf7243a45	true	userinfo.token.claim
8c8bf779-4e46-4747-bd7d-54acf7243a45	street	user.attribute.street
8c8bf779-4e46-4747-bd7d-54acf7243a45	true	id.token.claim
8c8bf779-4e46-4747-bd7d-54acf7243a45	region	user.attribute.region
8c8bf779-4e46-4747-bd7d-54acf7243a45	true	access.token.claim
8c8bf779-4e46-4747-bd7d-54acf7243a45	locality	user.attribute.locality
2add61d5-d1cc-4767-a0f8-2fe6a4cba596	true	introspection.token.claim
2add61d5-d1cc-4767-a0f8-2fe6a4cba596	true	userinfo.token.claim
2add61d5-d1cc-4767-a0f8-2fe6a4cba596	phoneNumberVerified	user.attribute
2add61d5-d1cc-4767-a0f8-2fe6a4cba596	true	id.token.claim
2add61d5-d1cc-4767-a0f8-2fe6a4cba596	true	access.token.claim
2add61d5-d1cc-4767-a0f8-2fe6a4cba596	phone_number_verified	claim.name
2add61d5-d1cc-4767-a0f8-2fe6a4cba596	boolean	jsonType.label
b2edd8cf-d274-45a2-8d7d-69d63ade9e84	true	introspection.token.claim
b2edd8cf-d274-45a2-8d7d-69d63ade9e84	true	userinfo.token.claim
b2edd8cf-d274-45a2-8d7d-69d63ade9e84	phoneNumber	user.attribute
b2edd8cf-d274-45a2-8d7d-69d63ade9e84	true	id.token.claim
b2edd8cf-d274-45a2-8d7d-69d63ade9e84	true	access.token.claim
b2edd8cf-d274-45a2-8d7d-69d63ade9e84	phone_number	claim.name
b2edd8cf-d274-45a2-8d7d-69d63ade9e84	String	jsonType.label
372ae9a6-bce0-451a-99e7-19b596e93dd3	true	introspection.token.claim
372ae9a6-bce0-451a-99e7-19b596e93dd3	true	access.token.claim
edc812b8-e0d7-40aa-8eb9-bc4619cee6f7	true	introspection.token.claim
edc812b8-e0d7-40aa-8eb9-bc4619cee6f7	true	multivalued
edc812b8-e0d7-40aa-8eb9-bc4619cee6f7	foo	user.attribute
edc812b8-e0d7-40aa-8eb9-bc4619cee6f7	true	access.token.claim
edc812b8-e0d7-40aa-8eb9-bc4619cee6f7	resource_access.${client_id}.roles	claim.name
edc812b8-e0d7-40aa-8eb9-bc4619cee6f7	String	jsonType.label
f4f13ffa-5345-42f3-bea7-9264a33a5406	true	introspection.token.claim
f4f13ffa-5345-42f3-bea7-9264a33a5406	true	multivalued
f4f13ffa-5345-42f3-bea7-9264a33a5406	foo	user.attribute
f4f13ffa-5345-42f3-bea7-9264a33a5406	true	access.token.claim
f4f13ffa-5345-42f3-bea7-9264a33a5406	realm_access.roles	claim.name
f4f13ffa-5345-42f3-bea7-9264a33a5406	String	jsonType.label
f423d814-5b05-4b16-9cc9-dffe6f4047cc	true	introspection.token.claim
f423d814-5b05-4b16-9cc9-dffe6f4047cc	true	access.token.claim
9f0f7cb7-4ea9-4d7b-8f41-ab60377c6596	true	introspection.token.claim
9f0f7cb7-4ea9-4d7b-8f41-ab60377c6596	true	multivalued
9f0f7cb7-4ea9-4d7b-8f41-ab60377c6596	foo	user.attribute
9f0f7cb7-4ea9-4d7b-8f41-ab60377c6596	true	id.token.claim
9f0f7cb7-4ea9-4d7b-8f41-ab60377c6596	true	access.token.claim
9f0f7cb7-4ea9-4d7b-8f41-ab60377c6596	groups	claim.name
9f0f7cb7-4ea9-4d7b-8f41-ab60377c6596	String	jsonType.label
f4a574b5-4595-4166-84a6-bd9f27ca75ed	true	introspection.token.claim
f4a574b5-4595-4166-84a6-bd9f27ca75ed	true	userinfo.token.claim
f4a574b5-4595-4166-84a6-bd9f27ca75ed	username	user.attribute
f4a574b5-4595-4166-84a6-bd9f27ca75ed	true	id.token.claim
f4a574b5-4595-4166-84a6-bd9f27ca75ed	true	access.token.claim
f4a574b5-4595-4166-84a6-bd9f27ca75ed	upn	claim.name
f4a574b5-4595-4166-84a6-bd9f27ca75ed	String	jsonType.label
234f3067-4f1e-4c63-9947-45097e7ef911	true	introspection.token.claim
234f3067-4f1e-4c63-9947-45097e7ef911	true	id.token.claim
234f3067-4f1e-4c63-9947-45097e7ef911	true	access.token.claim
47699d9c-5d73-45c3-9fc9-167dacb69a5e	AUTH_TIME	user.session.note
47699d9c-5d73-45c3-9fc9-167dacb69a5e	true	introspection.token.claim
47699d9c-5d73-45c3-9fc9-167dacb69a5e	true	id.token.claim
47699d9c-5d73-45c3-9fc9-167dacb69a5e	true	access.token.claim
47699d9c-5d73-45c3-9fc9-167dacb69a5e	auth_time	claim.name
47699d9c-5d73-45c3-9fc9-167dacb69a5e	long	jsonType.label
b2fad6e4-d8fb-42bc-b586-d60012b0a13d	true	introspection.token.claim
b2fad6e4-d8fb-42bc-b586-d60012b0a13d	true	access.token.claim
c5370c67-8bc9-4e55-9c6c-1e55dd0e9963	true	introspection.token.claim
c5370c67-8bc9-4e55-9c6c-1e55dd0e9963	true	userinfo.token.claim
c5370c67-8bc9-4e55-9c6c-1e55dd0e9963	locale	user.attribute
c5370c67-8bc9-4e55-9c6c-1e55dd0e9963	true	id.token.claim
c5370c67-8bc9-4e55-9c6c-1e55dd0e9963	true	access.token.claim
c5370c67-8bc9-4e55-9c6c-1e55dd0e9963	locale	claim.name
c5370c67-8bc9-4e55-9c6c-1e55dd0e9963	String	jsonType.label
0bb96502-6796-47c7-a7f6-fb66e6935195	asrp-catalog	included.client.audience
0bb96502-6796-47c7-a7f6-fb66e6935195	false	id.token.claim
0bb96502-6796-47c7-a7f6-fb66e6935195	false	lightweight.claim
0bb96502-6796-47c7-a7f6-fb66e6935195	true	access.token.claim
0bb96502-6796-47c7-a7f6-fb66e6935195	false	introspection.token.claim
0bb96502-6796-47c7-a7f6-fb66e6935195	false	userinfo.token.claim
\.


--
-- Data for Name: realm; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm (id, access_code_lifespan, user_action_lifespan, access_token_lifespan, account_theme, admin_theme, email_theme, enabled, events_enabled, events_expiration, login_theme, name, not_before, password_policy, registration_allowed, remember_me, reset_password_allowed, social, ssl_required, sso_idle_timeout, sso_max_lifespan, update_profile_on_soc_login, verify_email, master_admin_client, login_lifespan, internationalization_enabled, default_locale, reg_email_as_username, admin_events_enabled, admin_events_details_enabled, edit_username_allowed, otp_policy_counter, otp_policy_window, otp_policy_period, otp_policy_digits, otp_policy_alg, otp_policy_type, browser_flow, registration_flow, direct_grant_flow, reset_credentials_flow, client_auth_flow, offline_session_idle_timeout, revoke_refresh_token, access_token_life_implicit, login_with_email_allowed, duplicate_emails_allowed, docker_auth_flow, refresh_token_max_reuse, allow_user_managed_access, sso_max_lifespan_remember_me, sso_idle_timeout_remember_me, default_role) FROM stdin;
e42af33c-a898-43d7-a74a-41752eb401e5	60	300	60	\N	\N	\N	t	f	0	\N	master	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	04ef44ab-a9da-4f74-83cc-6286f9571307	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	10b4264e-2d4d-4ecf-98f8-a1848f488ad3	ea34474c-d836-45a2-bb69-3c24aa5aecc3	91d89739-c488-4681-b818-5919a01b3f41	a3ad244c-0a14-4d76-98ba-9aad17da3ec3	c120b351-6345-4afd-b962-b4cb48be12f4	2592000	f	900	t	f	151dfa34-47dd-4296-ac02-8042ccff8493	0	f	0	0	c4ab8b5b-22ca-47f4-8d4e-9e923a0e0886
513ce991-e46b-4e3b-a51e-c03c61f8f1ac	60	300	300	\N	\N	\N	t	f	0	\N	asrp	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	c1bcfd99-f029-4775-9d65-0db353bbe973	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	1674a41f-c9f0-4439-8cd0-cb276864d5ab	c6e70676-5639-484b-a267-8b678043f35c	15583ec4-3b3b-4468-a3eb-d6f7defc721d	d4844057-e775-483d-81e6-7c42fedaf88a	c4a15dab-f472-4ea4-bc2e-8454df256547	2592000	f	900	t	f	095456ba-483b-40b6-af07-4c260b1c01d9	0	f	0	0	855f5a56-1c23-4df8-acf5-12666652d32a
\.


--
-- Data for Name: realm_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_attribute (name, realm_id, value) FROM stdin;
_browser_header.contentSecurityPolicyReportOnly	e42af33c-a898-43d7-a74a-41752eb401e5	
_browser_header.xContentTypeOptions	e42af33c-a898-43d7-a74a-41752eb401e5	nosniff
_browser_header.referrerPolicy	e42af33c-a898-43d7-a74a-41752eb401e5	no-referrer
_browser_header.xRobotsTag	e42af33c-a898-43d7-a74a-41752eb401e5	none
_browser_header.xFrameOptions	e42af33c-a898-43d7-a74a-41752eb401e5	SAMEORIGIN
_browser_header.contentSecurityPolicy	e42af33c-a898-43d7-a74a-41752eb401e5	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	e42af33c-a898-43d7-a74a-41752eb401e5	1; mode=block
_browser_header.strictTransportSecurity	e42af33c-a898-43d7-a74a-41752eb401e5	max-age=31536000; includeSubDomains
bruteForceProtected	e42af33c-a898-43d7-a74a-41752eb401e5	false
permanentLockout	e42af33c-a898-43d7-a74a-41752eb401e5	false
maxTemporaryLockouts	e42af33c-a898-43d7-a74a-41752eb401e5	0
maxFailureWaitSeconds	e42af33c-a898-43d7-a74a-41752eb401e5	900
minimumQuickLoginWaitSeconds	e42af33c-a898-43d7-a74a-41752eb401e5	60
waitIncrementSeconds	e42af33c-a898-43d7-a74a-41752eb401e5	60
quickLoginCheckMilliSeconds	e42af33c-a898-43d7-a74a-41752eb401e5	1000
maxDeltaTimeSeconds	e42af33c-a898-43d7-a74a-41752eb401e5	43200
failureFactor	e42af33c-a898-43d7-a74a-41752eb401e5	30
realmReusableOtpCode	e42af33c-a898-43d7-a74a-41752eb401e5	false
firstBrokerLoginFlowId	e42af33c-a898-43d7-a74a-41752eb401e5	a4f88fd1-e081-449e-a104-4056b5bfa4f8
displayName	e42af33c-a898-43d7-a74a-41752eb401e5	Keycloak
displayNameHtml	e42af33c-a898-43d7-a74a-41752eb401e5	<div class="kc-logo-text"><span>Keycloak</span></div>
defaultSignatureAlgorithm	e42af33c-a898-43d7-a74a-41752eb401e5	RS256
offlineSessionMaxLifespanEnabled	e42af33c-a898-43d7-a74a-41752eb401e5	false
offlineSessionMaxLifespan	e42af33c-a898-43d7-a74a-41752eb401e5	5184000
_browser_header.contentSecurityPolicyReportOnly	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	
_browser_header.xContentTypeOptions	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	nosniff
_browser_header.referrerPolicy	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	no-referrer
_browser_header.xRobotsTag	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	none
_browser_header.xFrameOptions	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	SAMEORIGIN
_browser_header.contentSecurityPolicy	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	1; mode=block
_browser_header.strictTransportSecurity	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	max-age=31536000; includeSubDomains
bruteForceProtected	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	false
permanentLockout	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	false
maxTemporaryLockouts	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	0
maxFailureWaitSeconds	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	900
minimumQuickLoginWaitSeconds	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	60
waitIncrementSeconds	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	60
quickLoginCheckMilliSeconds	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	1000
maxDeltaTimeSeconds	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	43200
failureFactor	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	30
realmReusableOtpCode	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	false
defaultSignatureAlgorithm	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	RS256
offlineSessionMaxLifespanEnabled	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	false
offlineSessionMaxLifespan	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	5184000
actionTokenGeneratedByAdminLifespan	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	43200
actionTokenGeneratedByUserLifespan	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	300
oauth2DeviceCodeLifespan	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	600
oauth2DevicePollingInterval	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	5
webAuthnPolicyRpEntityName	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	keycloak
webAuthnPolicySignatureAlgorithms	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	ES256
webAuthnPolicyRpId	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	
webAuthnPolicyAttestationConveyancePreference	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	not specified
webAuthnPolicyAuthenticatorAttachment	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	not specified
webAuthnPolicyRequireResidentKey	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	not specified
webAuthnPolicyUserVerificationRequirement	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	not specified
webAuthnPolicyCreateTimeout	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	0
webAuthnPolicyAvoidSameAuthenticatorRegister	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	false
webAuthnPolicyRpEntityNamePasswordless	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	keycloak
webAuthnPolicySignatureAlgorithmsPasswordless	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	ES256
webAuthnPolicyRpIdPasswordless	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	
webAuthnPolicyAttestationConveyancePreferencePasswordless	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	not specified
webAuthnPolicyAuthenticatorAttachmentPasswordless	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	not specified
webAuthnPolicyRequireResidentKeyPasswordless	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	not specified
webAuthnPolicyUserVerificationRequirementPasswordless	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	not specified
webAuthnPolicyCreateTimeoutPasswordless	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	0
webAuthnPolicyAvoidSameAuthenticatorRegisterPasswordless	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	false
cibaBackchannelTokenDeliveryMode	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	poll
cibaExpiresIn	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	120
cibaInterval	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	5
cibaAuthRequestedUserHint	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	login_hint
parRequestUriLifespan	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	60
firstBrokerLoginFlowId	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	0880d953-d169-4c5f-b3df-554566057657
\.


--
-- Data for Name: realm_default_groups; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_default_groups (realm_id, group_id) FROM stdin;
\.


--
-- Data for Name: realm_enabled_event_types; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_enabled_event_types (realm_id, value) FROM stdin;
\.


--
-- Data for Name: realm_events_listeners; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_events_listeners (realm_id, value) FROM stdin;
e42af33c-a898-43d7-a74a-41752eb401e5	jboss-logging
513ce991-e46b-4e3b-a51e-c03c61f8f1ac	jboss-logging
\.


--
-- Data for Name: realm_localizations; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_localizations (realm_id, locale, texts) FROM stdin;
\.


--
-- Data for Name: realm_required_credential; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_required_credential (type, form_label, input, secret, realm_id) FROM stdin;
password	password	t	t	e42af33c-a898-43d7-a74a-41752eb401e5
password	password	t	t	513ce991-e46b-4e3b-a51e-c03c61f8f1ac
\.


--
-- Data for Name: realm_smtp_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_smtp_config (realm_id, value, name) FROM stdin;
\.


--
-- Data for Name: realm_supported_locales; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_supported_locales (realm_id, value) FROM stdin;
\.


--
-- Data for Name: redirect_uris; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.redirect_uris (client_id, value) FROM stdin;
9705949f-ee65-4669-ab9a-97d66354880f	/realms/master/account/*
274c18c2-3acb-4828-8113-a49c994b9349	/realms/master/account/*
44a76799-b57d-49de-8ef7-a40f36e843c0	/admin/master/console/*
9d0d9417-47fb-45b2-a9c9-107809fcb94e	/realms/asrp/account/*
86d116d5-00ba-4976-b027-c2c46298f970	/realms/asrp/account/*
215d5479-a28b-480f-88a4-d119a2ed849a	/admin/asrp/console/*
97153c86-824e-4ee5-999b-dc95800acaf8	/*
\.


--
-- Data for Name: required_action_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.required_action_config (required_action_id, value, name) FROM stdin;
\.


--
-- Data for Name: required_action_provider; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.required_action_provider (id, alias, name, realm_id, enabled, default_action, provider_id, priority) FROM stdin;
1de1093c-d1ba-4fc4-894e-974703a68eb3	VERIFY_EMAIL	Verify Email	e42af33c-a898-43d7-a74a-41752eb401e5	t	f	VERIFY_EMAIL	50
dd4dac6d-9da2-44f5-bfce-9ad3f25f556b	UPDATE_PROFILE	Update Profile	e42af33c-a898-43d7-a74a-41752eb401e5	t	f	UPDATE_PROFILE	40
9a193329-a52d-4ea1-8caf-2d40eaae24ed	CONFIGURE_TOTP	Configure OTP	e42af33c-a898-43d7-a74a-41752eb401e5	t	f	CONFIGURE_TOTP	10
20ee7155-cb9e-4361-9e38-7d6c36d897ca	UPDATE_PASSWORD	Update Password	e42af33c-a898-43d7-a74a-41752eb401e5	t	f	UPDATE_PASSWORD	30
b32d2d9a-d1c7-4142-973d-086b7c6f2026	TERMS_AND_CONDITIONS	Terms and Conditions	e42af33c-a898-43d7-a74a-41752eb401e5	f	f	TERMS_AND_CONDITIONS	20
a7914bdc-34c1-4659-854b-52a0f28cfab2	delete_account	Delete Account	e42af33c-a898-43d7-a74a-41752eb401e5	f	f	delete_account	60
1f5d4272-2cbf-495a-a720-8e5f4279402c	delete_credential	Delete Credential	e42af33c-a898-43d7-a74a-41752eb401e5	t	f	delete_credential	100
dc58c80b-28d2-4732-b07c-c024aa7a655b	update_user_locale	Update User Locale	e42af33c-a898-43d7-a74a-41752eb401e5	t	f	update_user_locale	1000
cf53b899-e951-45d7-b1ae-9804b7213621	webauthn-register	Webauthn Register	e42af33c-a898-43d7-a74a-41752eb401e5	t	f	webauthn-register	70
5175f5d3-f9a7-49ab-9909-bbfb67443e57	webauthn-register-passwordless	Webauthn Register Passwordless	e42af33c-a898-43d7-a74a-41752eb401e5	t	f	webauthn-register-passwordless	80
997b2a6b-50c1-4aec-98b4-e657c6fa6a33	VERIFY_PROFILE	Verify Profile	e42af33c-a898-43d7-a74a-41752eb401e5	t	f	VERIFY_PROFILE	90
e214c602-15d1-4605-b1a7-09659b7d9fdc	VERIFY_EMAIL	Verify Email	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	t	f	VERIFY_EMAIL	50
8bf5b46c-06c4-46d3-82dd-ff74c6051bc9	UPDATE_PROFILE	Update Profile	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	t	f	UPDATE_PROFILE	40
5cd08fd6-62a7-4d29-b9a7-641761749e7c	CONFIGURE_TOTP	Configure OTP	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	t	f	CONFIGURE_TOTP	10
687a0ef0-6269-4a6c-8083-4638efce7f53	UPDATE_PASSWORD	Update Password	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	t	f	UPDATE_PASSWORD	30
6f651586-fcef-4ce9-a9a8-9b77f127ace5	TERMS_AND_CONDITIONS	Terms and Conditions	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	f	f	TERMS_AND_CONDITIONS	20
0fc4c699-f700-4bf9-b0ad-2738611d8244	delete_account	Delete Account	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	f	f	delete_account	60
f653a0b7-7c91-4656-808f-5af5d72380e0	delete_credential	Delete Credential	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	t	f	delete_credential	100
02cfda2b-2203-4af7-89fd-1a2b98f0e6f7	update_user_locale	Update User Locale	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	t	f	update_user_locale	1000
73a1a153-5690-4dcf-bbcf-db217d1c4487	webauthn-register	Webauthn Register	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	t	f	webauthn-register	70
037812fb-73f8-442f-8e58-cc40c257192a	webauthn-register-passwordless	Webauthn Register Passwordless	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	t	f	webauthn-register-passwordless	80
56e88fbd-5363-468c-b0c7-7c39d5352e6f	VERIFY_PROFILE	Verify Profile	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	t	f	VERIFY_PROFILE	90
\.


--
-- Data for Name: resource_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_attribute (id, name, value, resource_id) FROM stdin;
\.


--
-- Data for Name: resource_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_policy (resource_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_scope (resource_id, scope_id) FROM stdin;
\.


--
-- Data for Name: resource_server; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server (id, allow_rs_remote_mgmt, policy_enforce_mode, decision_strategy) FROM stdin;
\.


--
-- Data for Name: resource_server_perm_ticket; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_perm_ticket (id, owner, requester, created_timestamp, granted_timestamp, resource_id, scope_id, resource_server_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_server_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_policy (id, name, description, type, decision_strategy, logic, resource_server_id, owner) FROM stdin;
\.


--
-- Data for Name: resource_server_resource; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_resource (id, name, type, icon_uri, owner, resource_server_id, owner_managed_access, display_name) FROM stdin;
\.


--
-- Data for Name: resource_server_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_scope (id, name, icon_uri, resource_server_id, display_name) FROM stdin;
\.


--
-- Data for Name: resource_uris; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_uris (resource_id, value) FROM stdin;
\.


--
-- Data for Name: role_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.role_attribute (id, role_id, name, value) FROM stdin;
\.


--
-- Data for Name: scope_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.scope_mapping (client_id, role_id) FROM stdin;
274c18c2-3acb-4828-8113-a49c994b9349	7f5317c2-e0ea-49e2-b0d4-da9f46c90c79
274c18c2-3acb-4828-8113-a49c994b9349	1fd720d8-3eac-4b1c-b2ab-4abe8ac95dd6
86d116d5-00ba-4976-b027-c2c46298f970	e0f5317f-4c91-4e41-a2c5-6414b6f1d943
86d116d5-00ba-4976-b027-c2c46298f970	3b70e7e8-f6c9-486a-b716-72c89734051b
\.


--
-- Data for Name: scope_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.scope_policy (scope_id, policy_id) FROM stdin;
\.


--
-- Data for Name: user_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_attribute (name, value, user_id, id, long_value_hash, long_value_hash_lower_case, long_value) FROM stdin;
\.


--
-- Data for Name: user_consent; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_consent (id, client_id, user_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: user_consent_client_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_consent_client_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: user_entity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_entity (id, email, email_constraint, email_verified, enabled, federation_link, first_name, last_name, realm_id, username, created_timestamp, service_account_client_link, not_before) FROM stdin;
6eb64b5f-a195-432b-8710-4bdab6e82254	\N	9bf777e4-ba12-4101-a74f-ec596c83411b	f	t	\N	\N	\N	e42af33c-a898-43d7-a74a-41752eb401e5	admin	1769000140271	\N	0
5e3a7290-c388-4929-afa9-1fd63d359842	asrp-catalog-writer@local	asrp-catalog-writer@local	t	t	\N	ASRP	CatalogWriter	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	asrp-catalog-writer	1769001836324	\N	0
b0d3bbef-ad49-4cb9-ba3b-c0a9b255c8ae	asrp-catalog-reader@local	asrp-catalog-reader@local	t	t	\N	ASRP	CatalogReader	513ce991-e46b-4e3b-a51e-c03c61f8f1ac	asrp-catalog-reader	1769002752552	\N	0
\.


--
-- Data for Name: user_federation_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_config (user_federation_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_mapper (id, name, federation_provider_id, federation_mapper_type, realm_id) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_mapper_config (user_federation_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_provider; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_provider (id, changed_sync_period, display_name, full_sync_period, last_sync, priority, provider_name, realm_id) FROM stdin;
\.


--
-- Data for Name: user_group_membership; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_group_membership (group_id, user_id) FROM stdin;
\.


--
-- Data for Name: user_required_action; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_required_action (user_id, required_action) FROM stdin;
\.


--
-- Data for Name: user_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_role_mapping (role_id, user_id) FROM stdin;
c4ab8b5b-22ca-47f4-8d4e-9e923a0e0886	6eb64b5f-a195-432b-8710-4bdab6e82254
a7988ea0-58e5-4014-ba01-9e3dcaf78161	6eb64b5f-a195-432b-8710-4bdab6e82254
5d84b698-8653-4c2f-b584-4c4769beadef	6eb64b5f-a195-432b-8710-4bdab6e82254
5c52c3bd-8543-45d6-8678-0a516f3648d8	6eb64b5f-a195-432b-8710-4bdab6e82254
9a0714d0-6335-4a38-a1f4-41e6a048fb10	6eb64b5f-a195-432b-8710-4bdab6e82254
f62b4f23-106d-4308-b379-341a7a935479	6eb64b5f-a195-432b-8710-4bdab6e82254
b5b1bfb5-3dfc-46eb-87c4-7571f2487d3f	6eb64b5f-a195-432b-8710-4bdab6e82254
bc9c63e3-237d-4cf4-b986-2649fe494f85	6eb64b5f-a195-432b-8710-4bdab6e82254
7832bc2f-f015-4b0a-bf8b-0fa2900fae2e	6eb64b5f-a195-432b-8710-4bdab6e82254
3b3a69a2-c41c-4f67-bee8-1e381e76d29f	6eb64b5f-a195-432b-8710-4bdab6e82254
7d8d6529-0427-4625-b072-eb9616a4cb92	6eb64b5f-a195-432b-8710-4bdab6e82254
a9bdb46d-630f-4c3d-9151-f3340a19c6f6	6eb64b5f-a195-432b-8710-4bdab6e82254
4b3bf52c-36b7-40c2-a1fa-722ea9348816	6eb64b5f-a195-432b-8710-4bdab6e82254
bcc9c7a7-0bda-420a-9a3e-a0b4b22178fb	6eb64b5f-a195-432b-8710-4bdab6e82254
ccdb7f9f-0ab9-4bf1-840f-abe6de17ac0b	6eb64b5f-a195-432b-8710-4bdab6e82254
3eeb7f5a-ad7f-435a-8068-7c2e1a9c9da5	6eb64b5f-a195-432b-8710-4bdab6e82254
5fb773f4-bf08-4960-8cfc-1230dc13dbe7	6eb64b5f-a195-432b-8710-4bdab6e82254
9fbe85d4-c37d-499c-a5b6-e48cc99f7f4d	6eb64b5f-a195-432b-8710-4bdab6e82254
ea28bb81-98a2-470b-bffd-8a05a5013d49	6eb64b5f-a195-432b-8710-4bdab6e82254
855f5a56-1c23-4df8-acf5-12666652d32a	5e3a7290-c388-4929-afa9-1fd63d359842
855f5a56-1c23-4df8-acf5-12666652d32a	b0d3bbef-ad49-4cb9-ba3b-c0a9b255c8ae
f94a4e7f-ab6b-4764-ae8f-f5471ea1da8e	b0d3bbef-ad49-4cb9-ba3b-c0a9b255c8ae
b3ff07b6-ce5b-4d99-a758-2bbf9f0e32fa	5e3a7290-c388-4929-afa9-1fd63d359842
\.


--
-- Data for Name: user_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_session (id, auth_method, ip_address, last_session_refresh, login_username, realm_id, remember_me, started, user_id, user_session_state, broker_session_id, broker_user_id) FROM stdin;
\.


--
-- Data for Name: user_session_note; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_session_note (user_session, name, value) FROM stdin;
\.


--
-- Data for Name: username_login_failure; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.username_login_failure (realm_id, username, failed_login_not_before, last_failure, last_ip_failure, num_failures) FROM stdin;
\.


--
-- Data for Name: web_origins; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.web_origins (client_id, value) FROM stdin;
44a76799-b57d-49de-8ef7-a40f36e843c0	+
215d5479-a28b-480f-88a4-d119a2ed849a	+
97153c86-824e-4ee5-999b-dc95800acaf8	/*
\.


--
-- Name: username_login_failure CONSTRAINT_17-2; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.username_login_failure
    ADD CONSTRAINT "CONSTRAINT_17-2" PRIMARY KEY (realm_id, username);


--
-- Name: org_domain ORG_DOMAIN_pkey; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.org_domain
    ADD CONSTRAINT "ORG_DOMAIN_pkey" PRIMARY KEY (id, name);


--
-- Name: org ORG_pkey; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT "ORG_pkey" PRIMARY KEY (id);


--
-- Name: keycloak_role UK_J3RWUVD56ONTGSUHOGM184WW2-2; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT "UK_J3RWUVD56ONTGSUHOGM184WW2-2" UNIQUE (name, client_realm_constraint);


--
-- Name: client_auth_flow_bindings c_cli_flow_bind; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_auth_flow_bindings
    ADD CONSTRAINT c_cli_flow_bind PRIMARY KEY (client_id, binding_name);


--
-- Name: client_scope_client c_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT c_cli_scope_bind PRIMARY KEY (client_id, scope_id);


--
-- Name: client_initial_access cnstr_client_init_acc_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT cnstr_client_init_acc_pk PRIMARY KEY (id);


--
-- Name: realm_default_groups con_group_id_def_groups; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT con_group_id_def_groups UNIQUE (group_id);


--
-- Name: broker_link constr_broker_link_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.broker_link
    ADD CONSTRAINT constr_broker_link_pk PRIMARY KEY (identity_provider, user_id);


--
-- Name: client_user_session_note constr_cl_usr_ses_note; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT constr_cl_usr_ses_note PRIMARY KEY (client_session, name);


--
-- Name: component_config constr_component_config_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT constr_component_config_pk PRIMARY KEY (id);


--
-- Name: component constr_component_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT constr_component_pk PRIMARY KEY (id);


--
-- Name: fed_user_required_action constr_fed_required_action; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_required_action
    ADD CONSTRAINT constr_fed_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: fed_user_attribute constr_fed_user_attr_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_attribute
    ADD CONSTRAINT constr_fed_user_attr_pk PRIMARY KEY (id);


--
-- Name: fed_user_consent constr_fed_user_consent_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_consent
    ADD CONSTRAINT constr_fed_user_consent_pk PRIMARY KEY (id);


--
-- Name: fed_user_credential constr_fed_user_cred_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_credential
    ADD CONSTRAINT constr_fed_user_cred_pk PRIMARY KEY (id);


--
-- Name: fed_user_group_membership constr_fed_user_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_group_membership
    ADD CONSTRAINT constr_fed_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: fed_user_role_mapping constr_fed_user_role; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_role_mapping
    ADD CONSTRAINT constr_fed_user_role PRIMARY KEY (role_id, user_id);


--
-- Name: federated_user constr_federated_user; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.federated_user
    ADD CONSTRAINT constr_federated_user PRIMARY KEY (id);


--
-- Name: realm_default_groups constr_realm_default_groups; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT constr_realm_default_groups PRIMARY KEY (realm_id, group_id);


--
-- Name: realm_enabled_event_types constr_realm_enabl_event_types; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT constr_realm_enabl_event_types PRIMARY KEY (realm_id, value);


--
-- Name: realm_events_listeners constr_realm_events_listeners; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT constr_realm_events_listeners PRIMARY KEY (realm_id, value);


--
-- Name: realm_supported_locales constr_realm_supported_locales; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT constr_realm_supported_locales PRIMARY KEY (realm_id, value);


--
-- Name: identity_provider constraint_2b; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT constraint_2b PRIMARY KEY (internal_id);


--
-- Name: client_attributes constraint_3c; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT constraint_3c PRIMARY KEY (client_id, name);


--
-- Name: event_entity constraint_4; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.event_entity
    ADD CONSTRAINT constraint_4 PRIMARY KEY (id);


--
-- Name: federated_identity constraint_40; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT constraint_40 PRIMARY KEY (identity_provider, user_id);


--
-- Name: realm constraint_4a; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT constraint_4a PRIMARY KEY (id);


--
-- Name: client_session_role constraint_5; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT constraint_5 PRIMARY KEY (client_session, role_id);


--
-- Name: user_session constraint_57; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_session
    ADD CONSTRAINT constraint_57 PRIMARY KEY (id);


--
-- Name: user_federation_provider constraint_5c; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT constraint_5c PRIMARY KEY (id);


--
-- Name: client_session_note constraint_5e; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT constraint_5e PRIMARY KEY (client_session, name);


--
-- Name: client constraint_7; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT constraint_7 PRIMARY KEY (id);


--
-- Name: client_session constraint_8; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT constraint_8 PRIMARY KEY (id);


--
-- Name: scope_mapping constraint_81; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT constraint_81 PRIMARY KEY (client_id, role_id);


--
-- Name: client_node_registrations constraint_84; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT constraint_84 PRIMARY KEY (client_id, name);


--
-- Name: realm_attribute constraint_9; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT constraint_9 PRIMARY KEY (name, realm_id);


--
-- Name: realm_required_credential constraint_92; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT constraint_92 PRIMARY KEY (realm_id, type);


--
-- Name: keycloak_role constraint_a; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT constraint_a PRIMARY KEY (id);


--
-- Name: admin_event_entity constraint_admin_event_entity; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.admin_event_entity
    ADD CONSTRAINT constraint_admin_event_entity PRIMARY KEY (id);


--
-- Name: authenticator_config_entry constraint_auth_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authenticator_config_entry
    ADD CONSTRAINT constraint_auth_cfg_pk PRIMARY KEY (authenticator_id, name);


--
-- Name: authentication_execution constraint_auth_exec_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT constraint_auth_exec_pk PRIMARY KEY (id);


--
-- Name: authentication_flow constraint_auth_flow_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT constraint_auth_flow_pk PRIMARY KEY (id);


--
-- Name: authenticator_config constraint_auth_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT constraint_auth_pk PRIMARY KEY (id);


--
-- Name: client_session_auth_status constraint_auth_status_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT constraint_auth_status_pk PRIMARY KEY (client_session, authenticator);


--
-- Name: user_role_mapping constraint_c; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT constraint_c PRIMARY KEY (role_id, user_id);


--
-- Name: composite_role constraint_composite_role; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT constraint_composite_role PRIMARY KEY (composite, child_role);


--
-- Name: client_session_prot_mapper constraint_cs_pmp_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT constraint_cs_pmp_pk PRIMARY KEY (client_session, protocol_mapper_id);


--
-- Name: identity_provider_config constraint_d; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT constraint_d PRIMARY KEY (identity_provider_id, name);


--
-- Name: policy_config constraint_dpc; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT constraint_dpc PRIMARY KEY (policy_id, name);


--
-- Name: realm_smtp_config constraint_e; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT constraint_e PRIMARY KEY (realm_id, name);


--
-- Name: credential constraint_f; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT constraint_f PRIMARY KEY (id);


--
-- Name: user_federation_config constraint_f9; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT constraint_f9 PRIMARY KEY (user_federation_provider_id, name);


--
-- Name: resource_server_perm_ticket constraint_fapmt; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT constraint_fapmt PRIMARY KEY (id);


--
-- Name: resource_server_resource constraint_farsr; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT constraint_farsr PRIMARY KEY (id);


--
-- Name: resource_server_policy constraint_farsrp; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT constraint_farsrp PRIMARY KEY (id);


--
-- Name: associated_policy constraint_farsrpap; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT constraint_farsrpap PRIMARY KEY (policy_id, associated_policy_id);


--
-- Name: resource_policy constraint_farsrpp; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT constraint_farsrpp PRIMARY KEY (resource_id, policy_id);


--
-- Name: resource_server_scope constraint_farsrs; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT constraint_farsrs PRIMARY KEY (id);


--
-- Name: resource_scope constraint_farsrsp; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT constraint_farsrsp PRIMARY KEY (resource_id, scope_id);


--
-- Name: scope_policy constraint_farsrsps; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT constraint_farsrsps PRIMARY KEY (scope_id, policy_id);


--
-- Name: user_entity constraint_fb; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT constraint_fb PRIMARY KEY (id);


--
-- Name: user_federation_mapper_config constraint_fedmapper_cfg_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT constraint_fedmapper_cfg_pm PRIMARY KEY (user_federation_mapper_id, name);


--
-- Name: user_federation_mapper constraint_fedmapperpm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT constraint_fedmapperpm PRIMARY KEY (id);


--
-- Name: fed_user_consent_cl_scope constraint_fgrntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_consent_cl_scope
    ADD CONSTRAINT constraint_fgrntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent_client_scope constraint_grntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT constraint_grntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent constraint_grntcsnt_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT constraint_grntcsnt_pm PRIMARY KEY (id);


--
-- Name: keycloak_group constraint_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT constraint_group PRIMARY KEY (id);


--
-- Name: group_attribute constraint_group_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT constraint_group_attribute_pk PRIMARY KEY (id);


--
-- Name: group_role_mapping constraint_group_role; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT constraint_group_role PRIMARY KEY (role_id, group_id);


--
-- Name: identity_provider_mapper constraint_idpm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT constraint_idpm PRIMARY KEY (id);


--
-- Name: idp_mapper_config constraint_idpmconfig; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT constraint_idpmconfig PRIMARY KEY (idp_mapper_id, name);


--
-- Name: migration_model constraint_migmod; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT constraint_migmod PRIMARY KEY (id);


--
-- Name: offline_client_session constraint_offl_cl_ses_pk3; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.offline_client_session
    ADD CONSTRAINT constraint_offl_cl_ses_pk3 PRIMARY KEY (user_session_id, client_id, client_storage_provider, external_client_id, offline_flag);


--
-- Name: offline_user_session constraint_offl_us_ses_pk2; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.offline_user_session
    ADD CONSTRAINT constraint_offl_us_ses_pk2 PRIMARY KEY (user_session_id, offline_flag);


--
-- Name: protocol_mapper constraint_pcm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT constraint_pcm PRIMARY KEY (id);


--
-- Name: protocol_mapper_config constraint_pmconfig; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT constraint_pmconfig PRIMARY KEY (protocol_mapper_id, name);


--
-- Name: redirect_uris constraint_redirect_uris; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT constraint_redirect_uris PRIMARY KEY (client_id, value);


--
-- Name: required_action_config constraint_req_act_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.required_action_config
    ADD CONSTRAINT constraint_req_act_cfg_pk PRIMARY KEY (required_action_id, name);


--
-- Name: required_action_provider constraint_req_act_prv_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT constraint_req_act_prv_pk PRIMARY KEY (id);


--
-- Name: user_required_action constraint_required_action; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT constraint_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: resource_uris constraint_resour_uris_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT constraint_resour_uris_pk PRIMARY KEY (resource_id, value);


--
-- Name: role_attribute constraint_role_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT constraint_role_attribute_pk PRIMARY KEY (id);


--
-- Name: user_attribute constraint_user_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT constraint_user_attribute_pk PRIMARY KEY (id);


--
-- Name: user_group_membership constraint_user_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT constraint_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: user_session_note constraint_usn_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT constraint_usn_pk PRIMARY KEY (user_session, name);


--
-- Name: web_origins constraint_web_origins; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT constraint_web_origins PRIMARY KEY (client_id, value);


--
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- Name: client_scope_attributes pk_cl_tmpl_attr; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT pk_cl_tmpl_attr PRIMARY KEY (scope_id, name);


--
-- Name: client_scope pk_cli_template; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT pk_cli_template PRIMARY KEY (id);


--
-- Name: resource_server pk_resource_server; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server
    ADD CONSTRAINT pk_resource_server PRIMARY KEY (id);


--
-- Name: client_scope_role_mapping pk_template_scope; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT pk_template_scope PRIMARY KEY (scope_id, role_id);


--
-- Name: default_client_scope r_def_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT r_def_cli_scope_bind PRIMARY KEY (realm_id, scope_id);


--
-- Name: realm_localizations realm_localizations_pkey; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_localizations
    ADD CONSTRAINT realm_localizations_pkey PRIMARY KEY (realm_id, locale);


--
-- Name: resource_attribute res_attr_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT res_attr_pk PRIMARY KEY (id);


--
-- Name: keycloak_group sibling_names; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT sibling_names UNIQUE (realm_id, parent_group, name);


--
-- Name: identity_provider uk_2daelwnibji49avxsrtuf6xj33; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT uk_2daelwnibji49avxsrtuf6xj33 UNIQUE (provider_alias, realm_id);


--
-- Name: client uk_b71cjlbenv945rb6gcon438at; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT uk_b71cjlbenv945rb6gcon438at UNIQUE (realm_id, client_id);


--
-- Name: client_scope uk_cli_scope; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT uk_cli_scope UNIQUE (realm_id, name);


--
-- Name: user_entity uk_dykn684sl8up1crfei6eckhd7; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_dykn684sl8up1crfei6eckhd7 UNIQUE (realm_id, email_constraint);


--
-- Name: user_consent uk_external_consent; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_external_consent UNIQUE (client_storage_provider, external_client_id, user_id);


--
-- Name: resource_server_resource uk_frsr6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5ha6 UNIQUE (name, owner, resource_server_id);


--
-- Name: resource_server_perm_ticket uk_frsr6t700s9v50bu18ws5pmt; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5pmt UNIQUE (owner, requester, resource_server_id, resource_id, scope_id);


--
-- Name: resource_server_policy uk_frsrpt700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT uk_frsrpt700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: resource_server_scope uk_frsrst700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT uk_frsrst700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: user_consent uk_local_consent; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_local_consent UNIQUE (client_id, user_id);


--
-- Name: org uk_org_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_group UNIQUE (group_id);


--
-- Name: org uk_org_name; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_name UNIQUE (realm_id, name);


--
-- Name: realm uk_orvsdmla56612eaefiq6wl5oi; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT uk_orvsdmla56612eaefiq6wl5oi UNIQUE (name);


--
-- Name: user_entity uk_ru8tt6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_ru8tt6t700s9v50bu18ws5ha6 UNIQUE (realm_id, username);


--
-- Name: fed_user_attr_long_values; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX fed_user_attr_long_values ON public.fed_user_attribute USING btree (long_value_hash, name);


--
-- Name: fed_user_attr_long_values_lower_case; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX fed_user_attr_long_values_lower_case ON public.fed_user_attribute USING btree (long_value_hash_lower_case, name);


--
-- Name: idx_admin_event_time; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_admin_event_time ON public.admin_event_entity USING btree (realm_id, admin_event_time);


--
-- Name: idx_assoc_pol_assoc_pol_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_assoc_pol_assoc_pol_id ON public.associated_policy USING btree (associated_policy_id);


--
-- Name: idx_auth_config_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_config_realm ON public.authenticator_config USING btree (realm_id);


--
-- Name: idx_auth_exec_flow; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_exec_flow ON public.authentication_execution USING btree (flow_id);


--
-- Name: idx_auth_exec_realm_flow; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_exec_realm_flow ON public.authentication_execution USING btree (realm_id, flow_id);


--
-- Name: idx_auth_flow_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_flow_realm ON public.authentication_flow USING btree (realm_id);


--
-- Name: idx_cl_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_cl_clscope ON public.client_scope_client USING btree (scope_id);


--
-- Name: idx_client_att_by_name_value; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_att_by_name_value ON public.client_attributes USING btree (name, substr(value, 1, 255));


--
-- Name: idx_client_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_id ON public.client USING btree (client_id);


--
-- Name: idx_client_init_acc_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_init_acc_realm ON public.client_initial_access USING btree (realm_id);


--
-- Name: idx_client_session_session; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_session_session ON public.client_session USING btree (session_id);


--
-- Name: idx_clscope_attrs; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_attrs ON public.client_scope_attributes USING btree (scope_id);


--
-- Name: idx_clscope_cl; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_cl ON public.client_scope_client USING btree (client_id);


--
-- Name: idx_clscope_protmap; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_protmap ON public.protocol_mapper USING btree (client_scope_id);


--
-- Name: idx_clscope_role; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_role ON public.client_scope_role_mapping USING btree (scope_id);


--
-- Name: idx_compo_config_compo; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_compo_config_compo ON public.component_config USING btree (component_id);


--
-- Name: idx_component_provider_type; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_component_provider_type ON public.component USING btree (provider_type);


--
-- Name: idx_component_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_component_realm ON public.component USING btree (realm_id);


--
-- Name: idx_composite; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_composite ON public.composite_role USING btree (composite);


--
-- Name: idx_composite_child; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_composite_child ON public.composite_role USING btree (child_role);


--
-- Name: idx_defcls_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_defcls_realm ON public.default_client_scope USING btree (realm_id);


--
-- Name: idx_defcls_scope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_defcls_scope ON public.default_client_scope USING btree (scope_id);


--
-- Name: idx_event_time; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_event_time ON public.event_entity USING btree (realm_id, event_time);


--
-- Name: idx_fedidentity_feduser; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fedidentity_feduser ON public.federated_identity USING btree (federated_user_id);


--
-- Name: idx_fedidentity_user; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fedidentity_user ON public.federated_identity USING btree (user_id);


--
-- Name: idx_fu_attribute; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_attribute ON public.fed_user_attribute USING btree (user_id, realm_id, name);


--
-- Name: idx_fu_cnsnt_ext; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_cnsnt_ext ON public.fed_user_consent USING btree (user_id, client_storage_provider, external_client_id);


--
-- Name: idx_fu_consent; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_consent ON public.fed_user_consent USING btree (user_id, client_id);


--
-- Name: idx_fu_consent_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_consent_ru ON public.fed_user_consent USING btree (realm_id, user_id);


--
-- Name: idx_fu_credential; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_credential ON public.fed_user_credential USING btree (user_id, type);


--
-- Name: idx_fu_credential_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_credential_ru ON public.fed_user_credential USING btree (realm_id, user_id);


--
-- Name: idx_fu_group_membership; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_group_membership ON public.fed_user_group_membership USING btree (user_id, group_id);


--
-- Name: idx_fu_group_membership_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_group_membership_ru ON public.fed_user_group_membership USING btree (realm_id, user_id);


--
-- Name: idx_fu_required_action; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_required_action ON public.fed_user_required_action USING btree (user_id, required_action);


--
-- Name: idx_fu_required_action_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_required_action_ru ON public.fed_user_required_action USING btree (realm_id, user_id);


--
-- Name: idx_fu_role_mapping; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_role_mapping ON public.fed_user_role_mapping USING btree (user_id, role_id);


--
-- Name: idx_fu_role_mapping_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_role_mapping_ru ON public.fed_user_role_mapping USING btree (realm_id, user_id);


--
-- Name: idx_group_att_by_name_value; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_group_att_by_name_value ON public.group_attribute USING btree (name, ((value)::character varying(250)));


--
-- Name: idx_group_attr_group; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_group_attr_group ON public.group_attribute USING btree (group_id);


--
-- Name: idx_group_role_mapp_group; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_group_role_mapp_group ON public.group_role_mapping USING btree (group_id);


--
-- Name: idx_id_prov_mapp_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_id_prov_mapp_realm ON public.identity_provider_mapper USING btree (realm_id);


--
-- Name: idx_ident_prov_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_ident_prov_realm ON public.identity_provider USING btree (realm_id);


--
-- Name: idx_keycloak_role_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_keycloak_role_client ON public.keycloak_role USING btree (client);


--
-- Name: idx_keycloak_role_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_keycloak_role_realm ON public.keycloak_role USING btree (realm);


--
-- Name: idx_offline_uss_by_broker_session_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_uss_by_broker_session_id ON public.offline_user_session USING btree (broker_session_id, realm_id);


--
-- Name: idx_offline_uss_by_last_session_refresh; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_uss_by_last_session_refresh ON public.offline_user_session USING btree (realm_id, offline_flag, last_session_refresh);


--
-- Name: idx_offline_uss_by_user; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_uss_by_user ON public.offline_user_session USING btree (user_id, realm_id, offline_flag);


--
-- Name: idx_perm_ticket_owner; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_perm_ticket_owner ON public.resource_server_perm_ticket USING btree (owner);


--
-- Name: idx_perm_ticket_requester; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_perm_ticket_requester ON public.resource_server_perm_ticket USING btree (requester);


--
-- Name: idx_protocol_mapper_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_protocol_mapper_client ON public.protocol_mapper USING btree (client_id);


--
-- Name: idx_realm_attr_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_attr_realm ON public.realm_attribute USING btree (realm_id);


--
-- Name: idx_realm_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_clscope ON public.client_scope USING btree (realm_id);


--
-- Name: idx_realm_def_grp_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_def_grp_realm ON public.realm_default_groups USING btree (realm_id);


--
-- Name: idx_realm_evt_list_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_evt_list_realm ON public.realm_events_listeners USING btree (realm_id);


--
-- Name: idx_realm_evt_types_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_evt_types_realm ON public.realm_enabled_event_types USING btree (realm_id);


--
-- Name: idx_realm_master_adm_cli; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_master_adm_cli ON public.realm USING btree (master_admin_client);


--
-- Name: idx_realm_supp_local_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_supp_local_realm ON public.realm_supported_locales USING btree (realm_id);


--
-- Name: idx_redir_uri_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_redir_uri_client ON public.redirect_uris USING btree (client_id);


--
-- Name: idx_req_act_prov_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_req_act_prov_realm ON public.required_action_provider USING btree (realm_id);


--
-- Name: idx_res_policy_policy; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_policy_policy ON public.resource_policy USING btree (policy_id);


--
-- Name: idx_res_scope_scope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_scope_scope ON public.resource_scope USING btree (scope_id);


--
-- Name: idx_res_serv_pol_res_serv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_serv_pol_res_serv ON public.resource_server_policy USING btree (resource_server_id);


--
-- Name: idx_res_srv_res_res_srv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_srv_res_res_srv ON public.resource_server_resource USING btree (resource_server_id);


--
-- Name: idx_res_srv_scope_res_srv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_srv_scope_res_srv ON public.resource_server_scope USING btree (resource_server_id);


--
-- Name: idx_role_attribute; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_role_attribute ON public.role_attribute USING btree (role_id);


--
-- Name: idx_role_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_role_clscope ON public.client_scope_role_mapping USING btree (role_id);


--
-- Name: idx_scope_mapping_role; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_scope_mapping_role ON public.scope_mapping USING btree (role_id);


--
-- Name: idx_scope_policy_policy; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_scope_policy_policy ON public.scope_policy USING btree (policy_id);


--
-- Name: idx_update_time; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_update_time ON public.migration_model USING btree (update_time);


--
-- Name: idx_us_sess_id_on_cl_sess; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_us_sess_id_on_cl_sess ON public.offline_client_session USING btree (user_session_id);


--
-- Name: idx_usconsent_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usconsent_clscope ON public.user_consent_client_scope USING btree (user_consent_id);


--
-- Name: idx_usconsent_scope_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usconsent_scope_id ON public.user_consent_client_scope USING btree (scope_id);


--
-- Name: idx_user_attribute; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_attribute ON public.user_attribute USING btree (user_id);


--
-- Name: idx_user_attribute_name; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_attribute_name ON public.user_attribute USING btree (name, value);


--
-- Name: idx_user_consent; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_consent ON public.user_consent USING btree (user_id);


--
-- Name: idx_user_credential; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_credential ON public.credential USING btree (user_id);


--
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_email ON public.user_entity USING btree (email);


--
-- Name: idx_user_group_mapping; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_group_mapping ON public.user_group_membership USING btree (user_id);


--
-- Name: idx_user_reqactions; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_reqactions ON public.user_required_action USING btree (user_id);


--
-- Name: idx_user_role_mapping; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_role_mapping ON public.user_role_mapping USING btree (user_id);


--
-- Name: idx_user_service_account; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_service_account ON public.user_entity USING btree (realm_id, service_account_client_link);


--
-- Name: idx_usr_fed_map_fed_prv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usr_fed_map_fed_prv ON public.user_federation_mapper USING btree (federation_provider_id);


--
-- Name: idx_usr_fed_map_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usr_fed_map_realm ON public.user_federation_mapper USING btree (realm_id);


--
-- Name: idx_usr_fed_prv_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usr_fed_prv_realm ON public.user_federation_provider USING btree (realm_id);


--
-- Name: idx_web_orig_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_web_orig_client ON public.web_origins USING btree (client_id);


--
-- Name: user_attr_long_values; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX user_attr_long_values ON public.user_attribute USING btree (long_value_hash, name);


--
-- Name: user_attr_long_values_lower_case; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX user_attr_long_values_lower_case ON public.user_attribute USING btree (long_value_hash_lower_case, name);


--
-- Name: client_session_auth_status auth_status_constraint; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT auth_status_constraint FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: identity_provider fk2b4ebc52ae5c3b34; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT fk2b4ebc52ae5c3b34 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_attributes fk3c47c64beacca966; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT fk3c47c64beacca966 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: federated_identity fk404288b92ef007a6; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT fk404288b92ef007a6 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_node_registrations fk4129723ba992f594; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT fk4129723ba992f594 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: client_session_note fk5edfb00ff51c2736; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT fk5edfb00ff51c2736 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: user_session_note fk5edfb00ff51d3472; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT fk5edfb00ff51d3472 FOREIGN KEY (user_session) REFERENCES public.user_session(id);


--
-- Name: client_session_role fk_11b7sgqw18i532811v7o2dv76; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT fk_11b7sgqw18i532811v7o2dv76 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: redirect_uris fk_1burs8pb4ouj97h5wuppahv9f; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT fk_1burs8pb4ouj97h5wuppahv9f FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: user_federation_provider fk_1fj32f6ptolw2qy60cd8n01e8; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT fk_1fj32f6ptolw2qy60cd8n01e8 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_session_prot_mapper fk_33a8sgqw18i532811v7o2dk89; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT fk_33a8sgqw18i532811v7o2dk89 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: realm_required_credential fk_5hg65lybevavkqfki3kponh9v; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT fk_5hg65lybevavkqfki3kponh9v FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_attribute fk_5hrm2vlf9ql5fu022kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu022kqepovbr FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: user_attribute fk_5hrm2vlf9ql5fu043kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu043kqepovbr FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: user_required_action fk_6qj3w1jw9cvafhe19bwsiuvmd; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT fk_6qj3w1jw9cvafhe19bwsiuvmd FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: keycloak_role fk_6vyqfe4cn4wlq8r6kt5vdsj5c; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT fk_6vyqfe4cn4wlq8r6kt5vdsj5c FOREIGN KEY (realm) REFERENCES public.realm(id);


--
-- Name: realm_smtp_config fk_70ej8xdxgxd0b9hh6180irr0o; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT fk_70ej8xdxgxd0b9hh6180irr0o FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_attribute fk_8shxd6l3e9atqukacxgpffptw; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT fk_8shxd6l3e9atqukacxgpffptw FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: composite_role fk_a63wvekftu8jo1pnj81e7mce2; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_a63wvekftu8jo1pnj81e7mce2 FOREIGN KEY (composite) REFERENCES public.keycloak_role(id);


--
-- Name: authentication_execution fk_auth_exec_flow; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_flow FOREIGN KEY (flow_id) REFERENCES public.authentication_flow(id);


--
-- Name: authentication_execution fk_auth_exec_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authentication_flow fk_auth_flow_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT fk_auth_flow_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authenticator_config fk_auth_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT fk_auth_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_session fk_b4ao2vcvat6ukau74wbwtfqo1; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT fk_b4ao2vcvat6ukau74wbwtfqo1 FOREIGN KEY (session_id) REFERENCES public.user_session(id);


--
-- Name: user_role_mapping fk_c4fqv34p1mbylloxang7b1q3l; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT fk_c4fqv34p1mbylloxang7b1q3l FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_scope_attributes fk_cl_scope_attr_scope; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT fk_cl_scope_attr_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope_role_mapping fk_cl_scope_rm_scope; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT fk_cl_scope_rm_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_user_session_note fk_cl_usr_ses_note; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT fk_cl_usr_ses_note FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: protocol_mapper fk_cli_scope_mapper; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_cli_scope_mapper FOREIGN KEY (client_scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_initial_access fk_client_init_acc_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT fk_client_init_acc_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: component_config fk_component_config; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT fk_component_config FOREIGN KEY (component_id) REFERENCES public.component(id);


--
-- Name: component fk_component_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT fk_component_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_default_groups fk_def_groups_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT fk_def_groups_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_mapper_config fk_fedmapper_cfg; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT fk_fedmapper_cfg FOREIGN KEY (user_federation_mapper_id) REFERENCES public.user_federation_mapper(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_fedprv; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_fedprv FOREIGN KEY (federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: associated_policy fk_frsr5s213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsr5s213xcx4wnkog82ssrfy FOREIGN KEY (associated_policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrasp13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrasp13xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog82sspmt; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82sspmt FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_resource fk_frsrho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog83sspmt; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog83sspmt FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog84sspmt; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog84sspmt FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: associated_policy fk_frsrpas14xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsrpas14xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrpass3xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrpass3xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_perm_ticket fk_frsrpo2128cx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrpo2128cx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_policy fk_frsrpo213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT fk_frsrpo213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_scope fk_frsrpos13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrpos13xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpos53xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpos53xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpp213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpp213xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_scope fk_frsrps213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrps213xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_scope fk_frsrso213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT fk_frsrso213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: composite_role fk_gr7thllb9lu8q4vqa4524jjy8; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_gr7thllb9lu8q4vqa4524jjy8 FOREIGN KEY (child_role) REFERENCES public.keycloak_role(id);


--
-- Name: user_consent_client_scope fk_grntcsnt_clsc_usc; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT fk_grntcsnt_clsc_usc FOREIGN KEY (user_consent_id) REFERENCES public.user_consent(id);


--
-- Name: user_consent fk_grntcsnt_user; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT fk_grntcsnt_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: group_attribute fk_group_attribute_group; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT fk_group_attribute_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: group_role_mapping fk_group_role_group; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT fk_group_role_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: realm_enabled_event_types fk_h846o4h0w8epx5nwedrf5y69j; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT fk_h846o4h0w8epx5nwedrf5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_events_listeners fk_h846o4h0w8epx5nxev9f5y69j; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT fk_h846o4h0w8epx5nxev9f5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: identity_provider_mapper fk_idpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT fk_idpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: idp_mapper_config fk_idpmconfig; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT fk_idpmconfig FOREIGN KEY (idp_mapper_id) REFERENCES public.identity_provider_mapper(id);


--
-- Name: web_origins fk_lojpho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT fk_lojpho213xcx4wnkog82ssrfy FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: scope_mapping fk_ouse064plmlr732lxjcn1q5f1; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT fk_ouse064plmlr732lxjcn1q5f1 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: protocol_mapper fk_pcm_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_pcm_realm FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: credential fk_pfyr0glasqyl0dei3kl69r6v0; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT fk_pfyr0glasqyl0dei3kl69r6v0 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: protocol_mapper_config fk_pmconfig; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT fk_pmconfig FOREIGN KEY (protocol_mapper_id) REFERENCES public.protocol_mapper(id);


--
-- Name: default_client_scope fk_r_def_cli_scope_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: required_action_provider fk_req_act_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT fk_req_act_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_uris fk_resource_server_uris; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT fk_resource_server_uris FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: role_attribute fk_role_attribute_id; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT fk_role_attribute_id FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- Name: realm_supported_locales fk_supported_locales_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT fk_supported_locales_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_config fk_t13hpu1j94r2ebpekr39x5eu5; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT fk_t13hpu1j94r2ebpekr39x5eu5 FOREIGN KEY (user_federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_group_membership fk_user_group_user; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT fk_user_group_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: policy_config fkdc34197cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT fkdc34197cf864c4e43 FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: identity_provider_config fkdc4897cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT fkdc4897cf864c4e43 FOREIGN KEY (identity_provider_id) REFERENCES public.identity_provider(internal_id);


--
-- PostgreSQL database dump complete
--

\unrestrict s4FANF5L4ujZ0HIN8k1UCkmAye4uuXuVMqcOq4ncDwSIskCpuSWSBPwTLJVYVXB

