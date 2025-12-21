--
-- PostgreSQL database dump
--

\restrict C2SmUSfThsqc2dqLP13XhzmHxNoj9hQDmKi96jRvwJdcKJscx8g8ynsBXIIdfN9

-- Dumped from database version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)

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

--
-- Name: drizzle; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA drizzle;


--
-- Name: neon_auth; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA neon_auth;


--
-- Name: pgrst; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA pgrst;


--
-- Name: discount_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.discount_status AS ENUM (
    'active',
    'scheduled',
    'expired',
    'disabled'
);


--
-- Name: discount_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.discount_type AS ENUM (
    'percentage',
    'fixed',
    'shipping'
);


--
-- Name: subscription_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.subscription_status AS ENUM (
    'active',
    'canceled',
    'expired',
    'past_due'
);


--
-- Name: user_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.user_role AS ENUM (
    'user',
    'admin'
);


--
-- Name: pre_config(); Type: FUNCTION; Schema: pgrst; Owner: -
--

CREATE FUNCTION pgrst.pre_config() RETURNS void
    LANGUAGE sql
    AS $$
  SELECT
      set_config('pgrst.db_schemas', 'public', true)
    , set_config('pgrst.db_aggregates_enabled', 'true', true)
    , set_config('pgrst.db_anon_role', 'anonymous', true)
    , set_config('pgrst.jwt_role_claim_key', '.role', true)
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: __drizzle_migrations; Type: TABLE; Schema: drizzle; Owner: -
--

CREATE TABLE drizzle.__drizzle_migrations (
    id integer NOT NULL,
    hash text NOT NULL,
    created_at bigint
);


--
-- Name: __drizzle_migrations_id_seq; Type: SEQUENCE; Schema: drizzle; Owner: -
--

CREATE SEQUENCE drizzle.__drizzle_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: __drizzle_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: drizzle; Owner: -
--

ALTER SEQUENCE drizzle.__drizzle_migrations_id_seq OWNED BY drizzle.__drizzle_migrations.id;


--
-- Name: users_sync; Type: TABLE; Schema: neon_auth; Owner: -
--

CREATE TABLE neon_auth.users_sync (
    raw_json jsonb NOT NULL,
    id text GENERATED ALWAYS AS ((raw_json ->> 'id'::text)) STORED NOT NULL,
    name text GENERATED ALWAYS AS ((raw_json ->> 'display_name'::text)) STORED,
    email text GENERATED ALWAYS AS ((raw_json ->> 'primary_email'::text)) STORED,
    created_at timestamp with time zone GENERATED ALWAYS AS (to_timestamp((trunc((((raw_json ->> 'signed_up_at_millis'::text))::bigint)::double precision) / (1000)::double precision))) STORED,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone
);


--
-- Name: cart_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cart_items (
    id integer NOT NULL,
    cart_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    variant_id integer NOT NULL
);


--
-- Name: cart_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cart_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cart_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cart_items_id_seq OWNED BY public.cart_items.id;


--
-- Name: carts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.carts (
    id integer NOT NULL,
    session_id text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: carts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.carts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: carts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.carts_id_seq OWNED BY public.carts.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    description text,
    parent_id integer,
    is_active boolean DEFAULT true,
    sort_order integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: contact_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contact_messages (
    id integer NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    phone text,
    subject text NOT NULL,
    message text NOT NULL,
    status text DEFAULT 'unread'::text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: contact_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contact_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contact_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contact_messages_id_seq OWNED BY public.contact_messages.id;


--
-- Name: discount_usage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.discount_usage (
    id integer NOT NULL,
    discount_id integer,
    user_id integer,
    order_id integer,
    session_id text,
    used_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: discount_usage_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.discount_usage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: discount_usage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.discount_usage_id_seq OWNED BY public.discount_usage.id;


--
-- Name: discounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.discounts (
    id integer NOT NULL,
    code text NOT NULL,
    type public.discount_type NOT NULL,
    value double precision NOT NULL,
    description text NOT NULL,
    min_purchase double precision DEFAULT 0,
    usage_limit integer DEFAULT 0,
    per_user boolean DEFAULT false,
    used integer DEFAULT 0,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone NOT NULL,
    status public.discount_status DEFAULT 'active'::public.discount_status NOT NULL,
    applicable_products text DEFAULT 'all'::text,
    applicable_categories text DEFAULT 'all'::text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: discounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.discounts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: discounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.discounts_id_seq OWNED BY public.discounts.id;


--
-- Name: email_change_verifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.email_change_verifications (
    id integer NOT NULL,
    user_id integer NOT NULL,
    new_email text NOT NULL,
    verification_token text NOT NULL,
    verified boolean DEFAULT false,
    expires_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: email_change_verifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.email_change_verifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: email_change_verifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.email_change_verifications_id_seq OWNED BY public.email_change_verifications.id;


--
-- Name: farmers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.farmers (
    id integer NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    phone text NOT NULL,
    specialty text NOT NULL,
    story text NOT NULL,
    location text NOT NULL,
    farm_name text,
    certification_status text DEFAULT 'none'::text,
    certification_details text,
    farm_size text,
    experience_years integer,
    website text,
    social_media text,
    bank_account text,
    pan_number text,
    aadhar_number text,
    image_url text NOT NULL,
    featured boolean DEFAULT false,
    verified boolean DEFAULT false,
    active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: farmers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.farmers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: farmers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.farmers_id_seq OWNED BY public.farmers.id;


--
-- Name: newsletter_subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.newsletter_subscriptions (
    id integer NOT NULL,
    name text,
    email text NOT NULL,
    agreed_to_terms boolean NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: newsletter_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.newsletter_subscriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: newsletter_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.newsletter_subscriptions_id_seq OWNED BY public.newsletter_subscriptions.id;


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_items (
    id integer NOT NULL,
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    price double precision NOT NULL,
    variant_id integer
);


--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    user_id integer,
    session_id text NOT NULL,
    payment_id text,
    total double precision NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    cancellation_approved_by text,
    cancellation_request_reason text,
    payment_method text DEFAULT 'razorpay'::text NOT NULL,
    discount_id integer,
    cancellation_reason text,
    delivered_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    customer_info jsonb,
    tracking_id text,
    status_timeline jsonb,
    cancellation_requested_at timestamp without time zone,
    cancellation_approved_at timestamp without time zone,
    cancellation_rejected_at timestamp without time zone,
    cancellation_rejection_reason text,
    total_weight numeric DEFAULT 0,
    shipping_cost numeric DEFAULT 0
);


--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    user_id integer NOT NULL,
    order_id integer,
    razorpay_payment_id text NOT NULL,
    amount double precision NOT NULL,
    currency text DEFAULT 'INR'::text NOT NULL,
    status text NOT NULL,
    method text,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: product_reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_reviews (
    id integer NOT NULL,
    product_id integer NOT NULL,
    user_id integer NOT NULL,
    order_id integer,
    customer_name text NOT NULL,
    rating double precision NOT NULL,
    review_text text NOT NULL,
    verified boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    variant_id integer
);


--
-- Name: product_reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_reviews_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_reviews_id_seq OWNED BY public.product_reviews.id;


--
-- Name: product_variants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_variants (
    id integer NOT NULL,
    product_id integer NOT NULL,
    price double precision NOT NULL,
    discount_price integer,
    quantity double precision NOT NULL,
    unit text NOT NULL,
    stock_quantity integer DEFAULT 0 NOT NULL,
    sku text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    weight numeric DEFAULT 0.5
);


--
-- Name: product_variants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_variants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_variants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_variants_id_seq OWNED BY public.product_variants.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id integer NOT NULL,
    name text NOT NULL,
    short_description text NOT NULL,
    description text NOT NULL,
    subcategory text NOT NULL,
    category text NOT NULL,
    image_url text NOT NULL,
    image_urls text[],
    thumbnail_url text,
    local_image_paths text[],
    video_url text,
    farmer_id integer NOT NULL,
    featured boolean DEFAULT false,
    naturally_grown boolean DEFAULT false,
    chemical_free boolean DEFAULT false,
    premium_quality boolean DEFAULT false,
    meta_title text,
    meta_description text,
    slug text,
    enable_share_buttons boolean DEFAULT true,
    enable_whatsapp_share boolean DEFAULT true,
    enable_facebook_share boolean DEFAULT true,
    enable_instagram_share boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: site_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.site_settings (
    id integer NOT NULL,
    key text NOT NULL,
    value text,
    type text DEFAULT 'text'::text NOT NULL,
    description text,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: site_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.site_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: site_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.site_settings_id_seq OWNED BY public.site_settings.id;


--
-- Name: sms_verifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sms_verifications (
    id integer NOT NULL,
    mobile text NOT NULL,
    otp text NOT NULL,
    purpose text NOT NULL,
    verified boolean DEFAULT false,
    expires_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: sms_verifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sms_verifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sms_verifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sms_verifications_id_seq OWNED BY public.sms_verifications.id;


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subscriptions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    razorpay_subscription_id text NOT NULL,
    plan_name text NOT NULL,
    status public.subscription_status DEFAULT 'active'::public.subscription_status NOT NULL,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.subscriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.subscriptions_id_seq OWNED BY public.subscriptions.id;


--
-- Name: team_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.team_members (
    id integer NOT NULL,
    name text NOT NULL,
    job_title text NOT NULL,
    description text NOT NULL,
    profile_image_url text NOT NULL,
    display_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: team_members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.team_members_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: team_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.team_members_id_seq OWNED BY public.team_members.id;


--
-- Name: testimonials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.testimonials (
    id integer NOT NULL,
    name text NOT NULL,
    title text NOT NULL,
    content text NOT NULL,
    rating double precision NOT NULL,
    image_initials text NOT NULL
);


--
-- Name: testimonials_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.testimonials_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: testimonials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.testimonials_id_seq OWNED BY public.testimonials.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    name text NOT NULL,
    role public.user_role DEFAULT 'user'::public.user_role NOT NULL,
    email_verified boolean DEFAULT false,
    verification_token text,
    reset_token text,
    reset_token_expiry timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    mobile text DEFAULT '0000000000'::text NOT NULL,
    mobile_verified boolean DEFAULT true NOT NULL,
    cod_enabled boolean DEFAULT true NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: __drizzle_migrations id; Type: DEFAULT; Schema: drizzle; Owner: -
--

ALTER TABLE ONLY drizzle.__drizzle_migrations ALTER COLUMN id SET DEFAULT nextval('drizzle.__drizzle_migrations_id_seq'::regclass);


--
-- Name: cart_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart_items ALTER COLUMN id SET DEFAULT nextval('public.cart_items_id_seq'::regclass);


--
-- Name: carts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.carts ALTER COLUMN id SET DEFAULT nextval('public.carts_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: contact_messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contact_messages ALTER COLUMN id SET DEFAULT nextval('public.contact_messages_id_seq'::regclass);


--
-- Name: discount_usage id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discount_usage ALTER COLUMN id SET DEFAULT nextval('public.discount_usage_id_seq'::regclass);


--
-- Name: discounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discounts ALTER COLUMN id SET DEFAULT nextval('public.discounts_id_seq'::regclass);


--
-- Name: email_change_verifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_change_verifications ALTER COLUMN id SET DEFAULT nextval('public.email_change_verifications_id_seq'::regclass);


--
-- Name: farmers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.farmers ALTER COLUMN id SET DEFAULT nextval('public.farmers_id_seq'::regclass);


--
-- Name: newsletter_subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.newsletter_subscriptions ALTER COLUMN id SET DEFAULT nextval('public.newsletter_subscriptions_id_seq'::regclass);


--
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: product_reviews id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_reviews ALTER COLUMN id SET DEFAULT nextval('public.product_reviews_id_seq'::regclass);


--
-- Name: product_variants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variants ALTER COLUMN id SET DEFAULT nextval('public.product_variants_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: site_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.site_settings ALTER COLUMN id SET DEFAULT nextval('public.site_settings_id_seq'::regclass);


--
-- Name: sms_verifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sms_verifications ALTER COLUMN id SET DEFAULT nextval('public.sms_verifications_id_seq'::regclass);


--
-- Name: subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions ALTER COLUMN id SET DEFAULT nextval('public.subscriptions_id_seq'::regclass);


--
-- Name: team_members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_members ALTER COLUMN id SET DEFAULT nextval('public.team_members_id_seq'::regclass);


--
-- Name: testimonials id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.testimonials ALTER COLUMN id SET DEFAULT nextval('public.testimonials_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: __drizzle_migrations; Type: TABLE DATA; Schema: drizzle; Owner: -
--

COPY drizzle.__drizzle_migrations (id, hash, created_at) FROM stdin;
\.


--
-- Data for Name: users_sync; Type: TABLE DATA; Schema: neon_auth; Owner: -
--

COPY neon_auth.users_sync (raw_json, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: cart_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cart_items (id, cart_id, product_id, quantity, variant_id) FROM stdin;
19	25	4	11	8
126	719	18	1	215
23	32	5	2	11
24	29	3	1	20
25	25	4	1	22
127	719	17	3	155
99	138	15	1	48
128	778	15	1	229
130	30	28	1	239
32	29	20	2	60
37	65	19	1	148
82	181	19	1	210
115	719	27	1	237
117	719	19	1	209
87	309	23	2	230
88	309	22	1	221
41	60	20	4	133
44	60	20	1	206
90	327	22	1	221
91	329	22	1	221
48	136	19	1	210
49	29	15	1	48
123	718	19	2	209
124	718	19	1	211
125	718	16	4	217
\.


--
-- Data for Name: carts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.carts (id, session_id, created_at, updated_at) FROM stdin;
2	28fbf75f-cbad-44b6-a0f8-05fd99b66db6	2025-08-11 05:44:41.695617	2025-08-11 05:44:41.695617
3	6e286e18-4eb5-4c7f-bc79-a075453b6026	2025-08-11 05:45:53.373404	2025-08-11 05:45:53.373404
4	a6240698-4368-4977-88f2-b2da642e69b8	2025-08-11 05:50:44.541956	2025-08-11 05:50:44.541956
5	90a37754-97f1-4ff8-91ee-f12253266a0e	2025-08-11 05:51:40.607694	2025-08-11 05:51:40.607694
6	6b87be24-2548-41b0-9362-6c5c21d9bc32	2025-08-11 05:59:57.529005	2025-08-11 05:59:57.529005
7	d41b9911-3d2c-48c7-b83f-dd2716dd310b	2025-08-11 06:03:59.212922	2025-08-11 06:03:59.212922
8	664ad042-528a-4cd3-bbfc-b83cd1dec408	2025-08-11 06:15:48.169184	2025-08-11 06:15:48.169184
9	11845f43-bbf4-47b5-a9aa-2fc2c935d53c	2025-08-11 06:17:26.39853	2025-08-11 06:17:26.39853
10	48426180-4b61-4f7a-9084-9067b93fd691	2025-08-11 06:27:04.365506	2025-08-11 06:27:04.365506
11	2c0b1aa5-1f5f-46fc-b212-0d3fde8a8dd0	2025-08-11 06:28:02.882901	2025-08-11 06:28:02.882901
12	a4a5a095-264c-4487-88a0-1b19d8829699	2025-08-11 06:34:41.173708	2025-08-11 06:34:41.173708
13	3a0bd3cd-3475-48b7-a8ee-a560e010cdb1	2025-08-11 06:35:37.226778	2025-08-11 06:35:37.226778
14	e5fad053-91e6-471d-96f0-d2b240ab5a97	2025-08-11 07:09:33.692597	2025-08-11 07:09:33.692597
15	7929917f-0108-43ec-a9bd-e94235842931	2025-08-13 11:07:35.777761	2025-08-13 11:07:35.777761
16	883a9d7c-f3c1-4730-ac12-34aaa0907620	2025-08-13 11:09:30.825013	2025-08-13 11:09:30.825013
17	2335f8bd-0caf-431f-b3c4-5317d427ee6e	2025-08-13 11:13:26.710326	2025-08-13 11:13:26.710326
18	079f895e-bc28-49ba-ad50-1262a0b91ee5	2025-08-13 11:20:00.108024	2025-08-13 11:20:00.108024
19	0a87a3a6-d892-4263-8933-e90b17ff0aed	2025-08-13 11:21:10.822398	2025-08-13 11:21:10.822398
20	3cc67500-78bf-461f-95f4-66c8487fe3be	2025-08-13 11:29:53.943794	2025-08-13 11:29:53.943794
21	603df199-0bde-465d-abaa-7e0d7a11502c	2025-08-13 11:34:33.281227	2025-08-13 11:34:33.281227
22	8a6e4849-7276-4984-8b47-e29fa6b53d98	2025-08-13 11:39:44.487126	2025-08-13 11:39:44.487126
23	473d6173-014e-435e-87c0-0ed6bb3c6380	2025-08-13 11:49:05.904151	2025-08-13 11:49:05.904151
24	3de3c5e1-d0cc-4eaf-ac8d-5c1d7c0f9cf5	2025-08-13 11:57:25.327665	2025-08-13 11:57:25.327665
35	25e3d345-0e8c-4c32-a094-48e70861b060	2025-08-14 04:15:36.55892	2025-08-14 04:15:36.55892
36	8a4db175-13c0-4ed2-9706-1d3dae04cffe	2025-08-14 04:21:39.381181	2025-08-14 04:21:39.381181
37	7506d8b0-449a-49c4-8cd3-aabd3a9f6bb3	2025-08-14 04:26:53.376816	2025-08-14 04:26:53.376816
38	83d98126-863c-4b25-94ac-64619784a648	2025-08-14 04:38:09.576505	2025-08-14 04:38:09.576505
25	26cd679d-9e2f-4ca4-b66b-ec24f5dbf8d4	2025-08-13 11:58:03.229838	2025-08-14 05:02:12.237
39	43ecabd3-087e-4c7c-81d2-55c3d985e97e	2025-08-14 05:03:55.559887	2025-08-14 05:03:55.559887
40	fc22c210-abab-4256-8512-3482e69c248c	2025-08-14 05:16:43.969716	2025-08-14 05:16:43.969716
41	21d761ff-21ab-4cb2-b3aa-b87db4767acf	2025-08-14 05:16:51.497084	2025-08-14 05:16:51.497084
42	ceda5d20-964c-4e47-9bb3-892941e2d719	2025-08-14 05:22:57.965154	2025-08-14 05:22:57.965154
43	72d99d14-e65a-4ac9-9586-2c23df54c175	2025-08-14 05:54:57.030942	2025-08-14 05:54:57.030942
44	a6120be4-0475-4c09-9f14-fddef505a5cf	2025-08-14 06:02:21.212806	2025-08-14 06:02:21.212806
45	6253b5ec-5cdb-44b6-9f69-d64be621d785	2025-08-14 06:08:43.814862	2025-08-14 06:08:43.814862
46	112dd279-4bf1-4064-984c-965f1780eb86	2025-08-14 07:01:17.661311	2025-08-14 07:01:17.661311
47	03dff3e4-f366-49c3-b7e5-2d647340cca2	2025-08-14 10:13:00.623573	2025-08-14 10:13:00.623573
26	d296145f-dde3-44bd-9d75-21ef104541e1	2025-08-13 12:19:33.595419	2025-08-13 12:19:33.595419
27	cf99e3e6-16f8-4f09-a440-6de67baadea7	2025-08-13 12:27:22.689956	2025-08-13 12:27:22.689956
31	bef33be7-a7d4-4310-82d0-9a9346c614d2	2025-08-14 01:44:01.895752	2025-08-14 01:44:01.895752
32	82472b3b-c5db-4d3c-ae5e-09e747ed94a8	2025-08-14 03:40:04.213827	2025-08-14 03:40:37.093
33	53451241-2d21-45eb-a322-986482bea963	2025-08-14 03:53:24.576529	2025-08-14 03:53:24.576529
34	a33d69ed-830c-4dd2-b447-94e4bef84583	2025-08-14 04:00:09.593726	2025-08-14 04:00:09.593726
68	6abd1536-63f7-4bce-b343-28434d982610	2025-08-16 06:47:55.377767	2025-08-16 06:47:55.377767
29	0853bf0d-4858-4e2b-ac95-8dd60f4477fd	2025-08-13 16:38:34.094902	2025-08-23 05:02:14.234
48	3fecd22f-a57f-4797-995a-4fd8504d3b01	2025-08-15 06:06:45.83586	2025-08-15 06:06:45.83586
49	57b5472a-5810-4ab6-adce-52dc3a980841	2025-08-15 06:36:41.54871	2025-08-15 06:36:41.54871
50	e6693a7d-dd4a-48ff-b4b8-7e3ec2ed3faa	2025-08-15 13:49:15.062004	2025-08-15 13:49:15.062004
51	21b9cad4-3e00-4ddb-889f-50cdd6e36aa1	2025-08-15 13:54:25.211417	2025-08-15 13:54:25.211417
52	1e90af99-dbc0-4122-9c1f-1e2c4869ccb1	2025-08-15 13:55:19.537825	2025-08-15 13:55:19.537825
53	45c654a2-ccb3-4fec-8a0a-5ce5c0c26875	2025-08-15 15:51:10.359926	2025-08-15 15:51:10.359926
69	6925ee5b-ffb2-4e25-b7c7-1fbe222df896	2025-08-16 07:19:48.683133	2025-08-16 07:19:48.683133
1	218ee3ba-4434-4ef0-8bff-3c7c06eb408d	2025-08-07 07:15:18.741721	2025-08-29 12:56:42.892
54	712a2245-2de8-466e-9ec6-0acd6d485ff9	2025-08-15 17:04:31.831723	2025-08-15 17:04:31.831723
55	00a1a7c6-cf9e-4140-a2b6-8d13c247d817	2025-08-16 03:15:37.825749	2025-08-16 03:15:37.825749
56	eded3c1d-b6c6-40d1-ba33-fe0e0e7d970d	2025-08-16 03:32:07.383984	2025-08-16 03:32:07.383984
70	b824bd7e-aa0b-462f-b2b0-8db1c7e761fd	2025-08-16 07:28:54.811508	2025-08-16 07:28:54.811508
71	8a39e693-e3a8-4add-8fd1-a716828ff815	2025-08-16 07:39:09.286561	2025-08-16 07:39:09.286561
57	21e2d5c4-04a3-4d2c-b0c9-83b03f7ce5ed	2025-08-16 03:39:14.230248	2025-08-16 03:40:08.266
58	f844725d-1164-4fb4-acae-a604d7c36beb	2025-08-16 03:43:51.146039	2025-08-16 03:43:51.146039
59	1f1fccab-660f-4f3e-b50d-c5d14c18a94e	2025-08-16 03:59:25.20456	2025-08-16 03:59:25.20456
61	98e24077-41b9-4444-9bf3-102fa6fe482c	2025-08-16 04:44:53.687088	2025-08-16 04:44:53.687088
62	94a9a785-70bc-43b8-85dc-f9fe79e7bcdb	2025-08-16 04:55:41.564172	2025-08-16 04:55:41.564172
63	c27ef34d-067f-4b60-b47f-9fd1c6a5897b	2025-08-16 05:03:58.954426	2025-08-16 05:03:58.954426
64	6a1166e9-ec6b-4c1e-a8ce-dded93f94542	2025-08-16 05:11:52.979791	2025-08-16 05:11:52.979791
72	f5b745f0-f1a7-4ef2-91a6-1743d5a8b66c	2025-08-16 07:46:51.613708	2025-08-16 07:46:51.613708
75	1cf1646a-aa2b-4d07-9d4e-7a542b0df18a	2025-08-16 10:34:53.995176	2025-08-16 10:34:53.995176
80	7a93d7f8-b1bb-4f20-9e9c-8df3bf5eed1c	2025-08-17 14:45:36.987985	2025-08-21 05:34:07.115
66	01765051-be5e-4492-9a55-e6f811db5809	2025-08-16 05:29:17.261409	2025-08-16 05:29:17.261409
67	c68507ed-b191-40df-82d9-11142c9f5c8d	2025-08-16 05:42:18.166837	2025-08-16 05:42:18.166837
76	5694fc67-1ad4-49a8-8b89-1423d6af7c81	2025-08-16 12:09:43.057711	2025-08-16 12:09:43.057711
77	5b6a3c41-8a2a-43c9-9103-3755bb88f0be	2025-08-16 12:10:46.583722	2025-08-16 12:10:46.583722
78	1fd8fc2a-4cb8-40ba-802d-862d3b973fc2	2025-08-16 19:47:34.475997	2025-08-16 19:47:34.475997
79	8361aca2-85b6-4150-b2b8-9935af07d1e3	2025-08-16 22:17:57.995365	2025-08-16 22:17:57.995365
28	c632b7da-53b8-4a9e-8e5f-b6408b76177f	2025-08-13 16:34:33.272157	2025-08-29 13:39:47.791
73	16d1ba12-62bd-4804-85ca-d2692e35086b	2025-08-16 09:28:18.738521	2025-08-16 09:28:18.738521
74	d7b043bb-9193-4c33-ae5a-9640aea03adb	2025-08-16 10:05:16.805005	2025-09-20 12:02:39.793
81	117cf43a-77fb-46a8-82e1-df2b8720d93b	2025-08-17 23:01:37.638396	2025-08-17 23:01:37.638396
82	9ee7655f-ee70-49a1-b3f5-9ca9a53d90cf	2025-08-18 00:06:22.340016	2025-08-18 00:06:22.340016
83	257469cf-9721-4bd8-b2e3-629678164fd0	2025-08-18 00:06:28.001941	2025-08-18 00:06:28.001941
84	aedeae1c-6b5d-46f6-ae1f-8ce792d8dd7c	2025-08-18 01:11:33.968874	2025-08-18 01:11:33.968874
85	7c3fd517-eae7-40e5-aa8f-3c99076ea698	2025-08-18 02:41:26.602758	2025-08-18 02:41:26.602758
86	8dd52c9a-cbd0-47e8-90a8-20ed3a1b9483	2025-08-18 11:31:38.589339	2025-08-18 11:31:38.589339
87	9cb7063d-f255-4157-9d12-14602873663e	2025-08-18 12:37:05.256621	2025-08-18 12:37:05.256621
88	d97e1208-ae73-4784-a15d-7a4bcc14e828	2025-08-19 06:22:35.975552	2025-08-19 06:22:35.975552
65	3685114d-d3c1-44db-a2b2-fff5b1149ce1	2025-08-16 05:14:31.222431	2025-08-20 08:55:25.146
60	042904d1-98c3-4e16-a8bc-a76711dddf24	2025-08-16 04:12:23.57243	2025-08-21 05:53:09.322
89	e94ab6ef-0601-4f68-bcf1-837582ef6b46	2025-08-19 06:25:03.989852	2025-08-19 06:25:03.989852
90	2c64ceae-92a5-4c36-b9b1-7ffe3b3a9a9c	2025-08-19 06:34:39.524641	2025-08-19 06:34:39.524641
91	81962a96-4ffb-4fbf-8dbb-724f3730c1c5	2025-08-19 06:59:03.809911	2025-08-19 06:59:03.809911
92	58fa09a5-94ed-40ad-95f7-da5c7e3c018a	2025-08-19 07:11:17.511646	2025-08-19 07:11:17.511646
93	df7f64ee-4704-4ea3-8ffd-af2a3c92996c	2025-08-19 09:20:19.887414	2025-08-19 09:20:19.887414
94	75ee9554-c607-42cb-87bd-4e0f717faf45	2025-08-19 09:50:38.835373	2025-08-19 09:50:38.835373
95	27494a70-7fe6-4228-ba39-da8b32e9e09c	2025-08-19 10:06:38.925529	2025-08-19 10:06:38.925529
96	9dd06d04-a076-4f8d-aad9-cfad6040f259	2025-08-19 10:10:29.493484	2025-08-19 10:10:29.493484
97	f836c8b1-474e-4e72-abde-26cd81133592	2025-08-19 10:32:36.677564	2025-08-19 10:32:36.677564
98	dcbb9c02-d588-48a2-9ff7-2187454a6b87	2025-08-19 11:51:46.429462	2025-08-19 11:51:46.429462
99	de9c724f-1a8b-4331-9b85-0d1bd934e8e7	2025-08-19 11:59:53.277774	2025-08-19 11:59:53.277774
100	ff1c4df0-1831-4a42-aed6-82c37dd67691	2025-08-19 12:07:35.837308	2025-08-19 12:07:35.837308
101	8c962b40-439f-4731-99b3-9ba889e323b5	2025-08-19 12:14:48.708486	2025-08-19 12:14:48.708486
102	b96bbe39-35a9-493f-82d5-8316774ad6fa	2025-08-19 12:17:37.902446	2025-08-19 12:17:37.902446
103	1602acc8-ed61-427b-934a-e1805ce590f6	2025-08-19 12:29:54.623096	2025-08-19 12:29:54.623096
104	fa291519-50fd-4fb5-9b4d-c3d41aac0169	2025-08-19 12:56:26.844037	2025-08-19 12:56:26.844037
154	ed092432-60dc-4910-bb94-ad95a1306923	2025-08-24 21:46:37.46835	2025-08-24 21:46:37.46835
105	bd64b831-09c4-44d6-bee9-0707e49d47da	2025-08-20 02:39:30.77193	2025-08-20 02:39:30.77193
155	4661a991-fed2-4f76-9c22-a14fafdc5d1e	2025-08-25 04:58:04.572284	2025-08-25 04:58:04.572284
106	dd42e6e4-5738-4f07-b369-44e546f729bb	2025-08-20 06:56:32.422152	2025-08-20 06:56:32.422152
156	c31ef1ef-c4de-4b63-9e13-047df224adfe	2025-08-25 04:59:03.529584	2025-08-25 04:59:03.529584
157	9a5c0296-9591-420c-a8c5-d831ec5c7c97	2025-08-25 04:59:47.848218	2025-08-25 04:59:47.848218
107	d260f9e3-af2e-48be-95e2-24a8e6cb28a1	2025-08-20 08:53:48.579374	2025-08-20 08:53:48.579374
108	fd404da6-9d39-43e2-8569-8ed40e616229	2025-08-20 09:19:37.329378	2025-08-20 09:19:37.329378
109	b9ea4978-b7e1-4525-84e4-f9808a319e67	2025-08-20 09:26:05.021846	2025-08-20 09:26:05.021846
110	190517ee-72f6-4f8a-9024-13a96e4cf766	2025-08-20 09:26:33.057747	2025-08-20 09:26:33.057747
111	714cf1af-7b18-4b1d-8e84-a94c24c22905	2025-08-20 09:26:53.530479	2025-08-20 09:26:53.530479
112	fe41692e-748b-4d1b-b5ed-3db7df2a4ac0	2025-08-20 09:45:15.467938	2025-08-20 09:45:15.467938
113	c58c0d0a-05b6-4c3b-aa49-38457cb3a756	2025-08-20 10:13:05.337127	2025-08-20 10:13:05.337127
114	22c4237b-6d75-4c01-9eac-f36177b81c1f	2025-08-20 11:09:36.269615	2025-08-20 11:09:36.269615
115	053fb6cf-80b7-4f85-b17e-bd47cb5577ac	2025-08-20 12:39:51.194411	2025-08-20 12:39:51.194411
116	6a8253ef-4daf-440d-8a4b-33dbaf0b7c5d	2025-08-20 16:20:41.335627	2025-08-20 16:20:41.335627
117	154fb09c-1e94-482b-a24b-51fc3f8066a2	2025-08-21 04:02:50.634439	2025-08-21 04:02:50.634439
118	5452dfc7-6d7c-4cc3-bd3a-cc399abfcaa5	2025-08-21 04:07:57.275347	2025-08-21 04:07:57.275347
119	c38de857-ec71-4b6b-b307-5069824d1308	2025-08-21 04:24:04.741106	2025-08-21 04:24:04.741106
120	b72b5ccf-8c92-4929-aa54-be56972ac94b	2025-08-21 04:26:07.938115	2025-08-21 04:26:07.938115
121	135978b3-9de0-40f1-bd0e-668b79e5a85c	2025-08-21 04:59:07.139623	2025-08-21 04:59:07.139623
165	7b60acdb-d6d3-411f-be40-69d14af55c89	2025-08-28 06:07:13.192002	2025-08-28 06:07:13.192002
166	311fdde1-347c-48e3-80b3-af7253e0b5a3	2025-08-28 12:17:55.8828	2025-08-28 12:17:55.8828
158	a279a229-310c-4de2-8bb9-1cfaa211a55f	2025-08-25 23:04:17.591935	2025-08-25 23:04:17.591935
122	81103375-a775-42f0-85f5-2010482f8017	2025-08-21 05:21:58.924803	2025-08-21 05:21:58.924803
123	f41bdd16-5b04-4024-b872-63ee1d69fc66	2025-08-21 05:23:05.81135	2025-08-21 05:23:05.81135
124	585c63c4-7957-45f1-b630-fcab409cd0c8	2025-08-21 05:32:24.369395	2025-08-21 05:32:24.369395
125	300b8ecb-37b8-4a77-adf5-8aa4c324d5bb	2025-08-21 05:48:02.518615	2025-08-21 05:48:02.518615
126	6deee0bb-463f-43fa-bd0a-465e5dd9b932	2025-08-21 06:01:41.736055	2025-08-21 06:01:41.736055
127	e1637457-2ef4-4978-ae50-4959e93076fe	2025-08-21 06:09:30.152656	2025-08-21 06:09:30.152656
167	366eaaa7-d991-4670-b505-31ddd0b17d54	2025-08-28 17:24:38.214026	2025-08-28 17:24:38.214026
128	55598d07-233e-457b-808a-8e1a05b61fd4	2025-08-21 07:20:59.10969	2025-08-21 07:20:59.10969
129	73f61a69-ae2e-48b6-a368-2c3def2c3192	2025-08-21 11:13:35.627021	2025-08-21 11:13:35.627021
130	ab0a4c17-111a-4afb-93b9-011a0fe1154c	2025-08-21 17:07:14.716868	2025-08-21 17:07:14.716868
131	3202ef62-ddd6-4a9d-b414-b9739d2c24bd	2025-08-21 21:03:58.537649	2025-08-21 21:03:58.537649
132	b8ffa260-5828-4a82-9523-342429ab3385	2025-08-21 21:04:42.874006	2025-08-21 21:04:42.874006
133	68236654-57e8-425b-93a9-89a0653d40e9	2025-08-21 21:43:11.312961	2025-08-21 21:43:11.312961
134	37dcdbcc-75d1-4aa5-a533-7dd3fe335636	2025-08-22 01:24:13.906504	2025-08-22 01:24:13.906504
135	a5c5c209-e61c-4d35-935c-bebd4ed527c4	2025-08-22 03:49:34.634713	2025-08-22 03:49:34.634713
159	c50bb569-541a-4edd-b7a9-f58fb35db7ae	2025-08-25 23:12:12.146111	2025-08-25 23:12:12.146111
160	ee2bb787-f1a6-4546-aa77-5dd41c372140	2025-08-26 07:16:49.465647	2025-08-26 07:16:49.465647
161	89cf7d71-ec28-43e3-8981-686e6714123c	2025-08-26 09:08:11.764204	2025-08-26 09:08:11.764204
137	a49be784-8c15-4f9f-a1a8-ce3a0b90690b	2025-08-22 05:07:19.096004	2025-08-22 05:07:19.096004
162	b52fd397-9eeb-4dd4-aba5-ef6a328b55ae	2025-08-26 10:37:21.21796	2025-08-26 10:37:21.21796
163	49d4e254-0fc3-4a84-9237-5aab06126668	2025-08-27 11:46:22.612386	2025-08-27 11:46:22.612386
136	fd4a7cd1-bfe6-4746-8c99-5f735150785c	2025-08-22 04:56:05.945834	2025-08-22 05:13:34.328
139	bf2915b7-aa3e-4853-85ee-59e11d989b75	2025-08-22 09:40:28.759771	2025-08-22 09:40:28.759771
140	70f5fdac-0277-4159-8647-c77c1016bf40	2025-08-22 09:41:09.687663	2025-08-22 09:41:09.687663
141	5916ba3e-bbf8-4fa4-bd42-3e32195e8bc4	2025-08-22 13:36:05.086802	2025-08-22 13:36:05.086802
142	47f3c25a-35c7-4732-a054-0d6416b8ae93	2025-08-22 13:52:39.823484	2025-08-22 13:52:39.823484
143	5d907edd-81e3-4494-b2ca-c67dda8b9a14	2025-08-23 01:52:42.500911	2025-08-23 01:52:42.500911
144	0361cd4c-5217-4d20-af89-b52e2326aa1a	2025-08-23 06:37:24.176671	2025-08-23 06:37:24.176671
145	702f1904-89a6-48e5-818a-5213f4bc38a1	2025-08-23 13:51:49.32551	2025-08-23 13:51:49.32551
146	ccf4f8e7-2bd6-446f-8702-2bdbd0e3e380	2025-08-23 14:14:01.571514	2025-08-23 14:14:01.571514
147	d3d5d379-3ac9-4873-ae99-cd88d8e733ae	2025-08-23 17:31:41.8242	2025-08-23 17:31:41.8242
148	36dd2a3f-c8d9-403c-b131-524dc7d569f2	2025-08-24 02:14:08.855003	2025-08-24 02:14:08.855003
149	56214637-8acd-4baa-a0fb-f8697f71757c	2025-08-24 04:35:39.704916	2025-08-24 04:35:39.704916
150	c0b59bc1-5f08-4a84-8f10-d1757f1a48e2	2025-08-24 09:53:31.671994	2025-08-24 09:53:31.671994
151	d8b8d09d-7382-4ac4-a8a8-a5f7ecbd87b6	2025-08-24 15:59:43.21821	2025-08-24 15:59:43.21821
152	e4753600-fdac-4b64-be4e-a9bcbf568875	2025-08-24 17:02:01.104676	2025-08-24 17:02:01.104676
153	e2bf979b-a50c-437e-a384-ef7f1608981f	2025-08-24 19:03:05.090651	2025-08-24 19:03:05.090651
164	bdf4a6da-41c9-4a31-8a40-a3aac844893b	2025-08-27 17:25:45.667532	2025-08-27 17:25:45.667532
138	7d2293a9-0205-4766-b95f-96fa2ceb9261	2025-08-22 06:03:39.08665	2025-09-29 12:11:47.946
168	f93c9e0b-35e7-4b93-a95e-9b4096b878c0	2025-08-28 18:25:38.690846	2025-08-28 18:25:38.690846
169	6ef59f03-c655-4060-bbd7-dbd66a452546	2025-08-28 18:44:35.179655	2025-08-28 18:44:35.179655
170	c961fbb3-fb6d-43a2-a68d-f611f591c711	2025-08-28 18:54:21.967277	2025-08-28 18:54:21.967277
171	d4f81f65-2757-4bb6-b7e1-19eb4e81ed77	2025-08-28 18:54:22.844758	2025-08-28 18:54:22.844758
172	4932a103-60e9-49ce-8037-9ffbe0bf7cc4	2025-08-28 18:54:23.476219	2025-08-28 18:54:23.476219
173	588752a5-64fc-4646-8968-a6626153f7f3	2025-08-28 18:58:01.952079	2025-08-28 18:58:01.952079
174	bd3dc19e-5d27-43c2-8f31-5bd542a0423d	2025-08-28 19:34:09.337508	2025-08-28 19:34:09.337508
175	a55b72a5-36a4-40fe-83d3-7c2bccb364d2	2025-08-28 19:41:05.684663	2025-08-28 19:41:05.684663
176	40a8060a-7b42-410e-9bc2-44f6141c1830	2025-08-29 10:13:19.561172	2025-08-29 10:13:19.561172
241	d1198e9f-6ea0-4aaa-97f3-27e32c73b21a	2025-08-30 22:01:17.861859	2025-08-30 22:01:17.861859
242	10872629-27f4-468d-9b5f-099babee9fd7	2025-08-30 22:15:57.460448	2025-08-30 22:15:57.460448
243	2d34b0d2-c1f0-4eb2-b43d-22d607d7b52a	2025-08-30 22:30:30.746603	2025-08-30 22:30:30.746603
177	ebcd20da-4dca-4501-935b-e537516d3906	2025-08-29 13:01:15.984959	2025-08-29 13:02:14.494
244	c189cf05-d139-4543-b655-d3c300906fa4	2025-08-30 22:42:37.053094	2025-08-30 22:42:37.053094
245	ca2e33a8-f093-4adc-9061-1636ac6e6d95	2025-08-30 22:43:44.40433	2025-08-30 22:43:44.40433
178	ed85c6ac-4d59-443a-a58c-a79eaa31b7b9	2025-08-29 13:02:30.120041	2025-08-29 13:03:14.749
179	496b0e9a-2fdb-4155-888c-cca5ac978de4	2025-08-29 13:34:35.239037	2025-08-29 13:34:35.239037
180	00511192-d1a7-452d-8602-679e51c97785	2025-08-29 13:45:25.45026	2025-08-29 13:45:25.45026
181	b557cf54-5247-44f7-a195-ff7916ea5290	2025-08-29 13:54:23.543328	2025-08-29 14:17:37.306
246	9cba27ea-88dc-4880-ba36-0e41f065351a	2025-08-30 23:19:59.901117	2025-08-30 23:19:59.901117
247	adf33be2-3cf3-4b11-b824-0124db8e5396	2025-08-30 23:30:41.188403	2025-08-30 23:30:41.188403
182	25f19707-4173-4db1-af2e-2980dd091888	2025-08-29 14:19:54.364964	2025-08-29 14:21:20.203
183	1055fb4e-dc21-49ac-beac-90430ab6ac3f	2025-08-29 18:52:54.698783	2025-08-29 18:52:54.698783
184	a45bf701-7802-4e3f-ace9-4646308547ae	2025-08-29 20:07:32.588411	2025-08-29 20:07:32.588411
185	56823473-d0f6-480e-91be-afea9a20f673	2025-08-29 21:19:59.597618	2025-08-29 21:19:59.597618
186	a546a74e-e150-434c-9d2c-585ac504eadf	2025-08-30 04:00:42.037735	2025-08-30 04:00:42.037735
187	e7bb0669-4f54-4765-8bb6-ad97969985bc	2025-08-30 04:00:46.301628	2025-08-30 04:00:46.301628
188	0e6ca4dd-6e03-4b3b-ad21-0d38faf70f52	2025-08-30 04:51:43.181558	2025-08-30 04:51:43.181558
189	5d4c0620-eeed-4ddd-b872-3ea785aeaab7	2025-08-30 12:04:16.34592	2025-08-30 12:04:16.34592
190	834fde61-6d85-4f9f-a2b7-d53bc60e98e9	2025-08-30 12:04:17.451228	2025-08-30 12:04:17.451228
191	f2228e2a-bf1e-4e2f-84e0-c6e2e327f5ca	2025-08-30 12:04:17.615286	2025-08-30 12:04:17.615286
192	14a7cda2-a8f5-4bda-a180-2090f54ee2ca	2025-08-30 12:05:19.78341	2025-08-30 12:05:19.78341
193	8f527a09-09c3-455e-8a98-c1405557f795	2025-08-30 12:05:38.664514	2025-08-30 12:05:38.664514
194	074c2908-77a5-4306-9528-5ae011d20892	2025-08-30 12:12:01.185725	2025-08-30 12:12:01.185725
195	50b9c0c1-95d1-464d-8ee2-1683d87b6e36	2025-08-30 12:32:28.310079	2025-08-30 12:32:28.310079
196	f8cbb63d-3c3b-4f46-a54c-2977a39d2687	2025-08-30 12:47:13.581098	2025-08-30 12:47:13.581098
197	20f0d645-c4e4-4919-9625-f1256112dca2	2025-08-30 13:16:25.17963	2025-08-30 13:16:25.17963
198	e93a7bc2-0182-42a7-b3a4-a23c2ea7bf48	2025-08-30 13:20:55.902493	2025-08-30 13:20:55.902493
199	e62c62f2-1c85-42d6-a60a-ebe5665b2010	2025-08-30 13:25:47.039654	2025-08-30 13:25:47.039654
200	7a33a183-44a6-427d-931c-cfd4d9110efc	2025-08-30 13:42:45.430674	2025-08-30 13:42:45.430674
201	5bc0f944-0e86-4c2a-a68c-24c524a0a798	2025-08-30 14:01:50.368994	2025-08-30 14:01:50.368994
202	6bc3749f-c60c-4aaf-9971-d1635deb0274	2025-08-30 14:09:41.589003	2025-08-30 14:09:41.589003
203	50c69c7a-db87-41b9-9ca9-90321fee2dc3	2025-08-30 14:09:58.532797	2025-08-30 14:09:58.532797
204	4fbd5e78-f3d6-4a4e-9ce4-981eef74f7d2	2025-08-30 14:33:30.100399	2025-08-30 14:33:30.100399
205	cac7d59c-b3ae-48f4-a7c3-4e94e4db0baf	2025-08-30 14:35:55.976439	2025-08-30 14:35:55.976439
206	8afe2605-df4f-4459-96ec-2549197d1b1a	2025-08-30 15:03:12.746988	2025-08-30 15:03:12.746988
207	a986896e-f883-419b-af69-a40f29b3e192	2025-08-30 15:12:31.383188	2025-08-30 15:12:31.383188
208	1a6c2d66-837a-409d-8f94-99771162bdc7	2025-08-30 15:16:30.115818	2025-08-30 15:16:30.115818
209	bfcb12c3-3fc6-4df3-af27-21cee6f881d7	2025-08-30 15:16:59.00619	2025-08-30 15:16:59.00619
210	e5468dd6-d154-4589-b05b-97f57b97dd75	2025-08-30 15:17:15.477135	2025-08-30 15:17:15.477135
211	36dfb145-7847-4ec7-bc32-dd236c872458	2025-08-30 15:31:39.805662	2025-08-30 15:31:39.805662
212	c04aceee-cfb6-4aa2-80ac-2fbefa0a12c1	2025-08-30 15:50:36.867473	2025-08-30 15:50:36.867473
213	1861143f-2af7-41cc-ba17-241dbce9de70	2025-08-30 16:02:32.006619	2025-08-30 16:02:32.006619
214	05a7b7b1-73bf-4c18-8b94-146398e1eddc	2025-08-30 16:05:15.185691	2025-08-30 16:05:15.185691
215	7e5df0ab-a906-4233-a3e4-9fa0c69d6c6f	2025-08-30 16:08:51.742348	2025-08-30 16:08:51.742348
216	757b831e-2c74-4526-a65a-0bf6d8599af2	2025-08-30 16:28:07.57571	2025-08-30 16:28:07.57571
217	75aa144d-56e2-43ea-a4ef-7131cd5d8a30	2025-08-30 16:31:02.178005	2025-08-30 16:31:02.178005
218	e8d8502d-b171-45ae-a8f5-cb1cb7bd8d7c	2025-08-30 16:58:41.681395	2025-08-30 16:58:41.681395
219	2c9cf5c3-a9e4-4af0-964d-84fc07a7e61c	2025-08-30 17:19:55.812153	2025-08-30 17:19:55.812153
220	f922be58-60b0-4c73-ae35-569d65bdfe0c	2025-08-30 17:31:12.352031	2025-08-30 17:31:12.352031
221	1760a57e-44ac-45f9-9670-4b6350832b28	2025-08-30 17:36:13.71092	2025-08-30 17:36:13.71092
222	722d92a7-c322-457d-87a7-ff9579e50951	2025-08-30 17:40:08.424504	2025-08-30 17:40:08.424504
223	d052568c-957a-4257-b36f-59af984c4360	2025-08-30 17:41:27.496926	2025-08-30 17:41:27.496926
224	6c0d31e2-da9f-4bd5-912c-354e6f649472	2025-08-30 17:57:11.713951	2025-08-30 17:57:11.713951
225	de536e4e-3e6a-49d8-9c76-fac65bdb12b3	2025-08-30 18:05:35.694066	2025-08-30 18:05:35.694066
226	0e3bb58c-15e7-4593-84a3-5bb63212ea86	2025-08-30 18:09:10.828031	2025-08-30 18:09:10.828031
227	e8dd7b27-6c92-4ed6-991e-aeb2cad0839c	2025-08-30 18:16:18.049151	2025-08-30 18:16:18.049151
228	e54390b7-f13a-42de-873c-d104a06ac214	2025-08-30 18:19:21.595629	2025-08-30 18:19:21.595629
229	13f4429d-6c70-4a96-8520-5b529bf7ed93	2025-08-30 18:26:41.589993	2025-08-30 18:26:41.589993
230	f27fee84-f735-41f4-9c7d-fa606f07038b	2025-08-30 18:26:49.695404	2025-08-30 18:26:49.695404
248	bf464d62-8b94-4a6c-87ea-82d5bbea93a2	2025-08-30 23:43:49.375867	2025-08-30 23:43:49.375867
249	be83165d-36fd-4db1-80b6-56c0ceaf6dff	2025-08-30 23:52:54.366265	2025-08-30 23:52:54.366265
250	e7d2e9fb-606b-48bd-ad88-b2910e76330d	2025-08-31 00:30:00.538285	2025-08-31 00:30:00.538285
232	bb956aa1-5ddd-4fe9-85f5-2eac924162be	2025-08-30 18:51:11.18265	2025-08-30 18:51:11.18265
233	50680693-6f70-4ffa-ae95-29719bd7cd72	2025-08-30 18:59:23.541509	2025-08-30 18:59:23.541509
234	dacb78b6-9805-4130-8ff3-3f07edfcbf53	2025-08-30 19:35:04.178105	2025-08-30 19:35:04.178105
235	1d904238-c631-4965-a805-89e38a1efdf2	2025-08-30 19:36:22.527301	2025-08-30 19:36:22.527301
236	d7235fba-34fb-4fdf-833e-848ed6eb2645	2025-08-30 19:38:54.123338	2025-08-30 19:38:54.123338
237	33f825ce-be95-4fc5-a604-6942c43ab148	2025-08-30 19:41:40.497572	2025-08-30 19:41:40.497572
238	2e092e10-f4f8-4aea-9fb0-86501cec5d84	2025-08-30 19:58:29.378855	2025-08-30 19:58:29.378855
239	dc66a4a0-2114-48fc-92af-3cbbc970e2e3	2025-08-30 21:48:27.942613	2025-08-30 21:48:27.942613
240	4bd4d218-91f2-459a-88c0-4ec722297c4f	2025-08-30 21:51:29.166732	2025-08-30 21:51:29.166732
251	5d570851-59b6-4e88-b50d-657ea1a757e6	2025-08-31 00:40:13.011767	2025-08-31 00:40:13.011767
252	68a36435-af65-4e3c-9a00-73fd1760035d	2025-08-31 00:52:00.858846	2025-08-31 00:52:00.858846
253	638e7a2e-6e4b-41eb-aefe-7e2622ca21a7	2025-08-31 01:13:35.756199	2025-08-31 01:13:35.756199
254	52b5373e-c123-4208-af92-2251984812ab	2025-08-31 01:14:51.069063	2025-08-31 01:14:51.069063
255	a5b347f4-ac28-4656-9172-7f19b11f23fc	2025-08-31 02:49:23.054916	2025-08-31 02:49:23.054916
256	d04acd92-1b1b-43aa-9635-e194058c98ce	2025-08-31 03:34:31.643925	2025-08-31 03:34:31.643925
257	b24e63da-999d-4e38-a4bb-4c47385e833c	2025-08-31 03:46:21.955915	2025-08-31 03:46:21.955915
258	0805ccb6-aed0-47d8-9d0c-2e8828f86602	2025-08-31 04:36:37.59785	2025-08-31 04:36:37.59785
259	a1be9a66-46bf-4441-84d6-1ca181b5a685	2025-08-31 04:39:52.157461	2025-08-31 04:39:52.157461
260	7a4e62b9-18a2-41c7-b0d6-bc56f98c5740	2025-08-31 05:07:29.857855	2025-08-31 05:07:29.857855
261	5c1b4659-cc6a-4f26-81d6-0b20670c22cf	2025-08-31 05:13:12.032773	2025-08-31 05:13:12.032773
262	a60b1332-09cb-4935-ab35-eb219ebe4da4	2025-08-31 05:17:09.69977	2025-08-31 05:17:09.69977
263	52a734d1-227a-4803-8e35-373359e82f3f	2025-08-31 05:17:36.888449	2025-08-31 05:17:36.888449
264	57471d1c-2456-4559-9fea-37a683e46c90	2025-08-31 05:23:03.352798	2025-08-31 05:23:03.352798
265	48e9479d-d787-4f28-971f-bfe27552685e	2025-08-31 05:28:48.89106	2025-08-31 05:28:48.89106
266	01cfd88c-2995-44e0-b0ff-85ec5357b890	2025-08-31 05:31:34.821658	2025-08-31 05:31:34.821658
267	3db40b74-9abc-4a8f-a526-3bd9b1099f7c	2025-08-31 05:33:04.934043	2025-08-31 05:33:04.934043
268	f8f365bf-b109-42e4-96b6-f449f2321f40	2025-08-31 05:44:13.1059	2025-08-31 05:44:13.1059
269	92a82273-07da-4b97-aec5-67a200aa0974	2025-08-31 05:48:33.259765	2025-08-31 05:48:33.259765
270	cfe6e188-54a8-4750-b9d7-3d860f1c9b7c	2025-08-31 05:50:06.000639	2025-08-31 05:50:06.000639
271	df3c55c2-89b6-42aa-9e1b-938e4388490f	2025-08-31 05:54:02.115945	2025-08-31 05:54:02.115945
272	babe7bdd-6c8c-46a9-a966-f71a4ac7cb0a	2025-08-31 06:02:29.940143	2025-08-31 06:02:29.940143
273	7e60cbe7-1127-452e-9485-96f045527a30	2025-08-31 06:22:05.059732	2025-08-31 06:22:05.059732
274	c092d285-a346-45f7-9931-707a92eb8f04	2025-08-31 06:25:28.77935	2025-08-31 06:25:28.77935
275	9dc63eb2-ffdd-4108-bf52-65afcf5c634e	2025-08-31 06:37:33.212658	2025-08-31 06:37:33.212658
276	c7bc306a-9c9e-4710-9af1-add055d708c4	2025-08-31 06:38:27.710533	2025-08-31 06:38:27.710533
277	308f38e9-b481-414e-a64d-3f933d9edf43	2025-08-31 06:43:57.172151	2025-08-31 06:43:57.172151
278	1f5cd32e-7164-4131-a3e6-724828d64391	2025-08-31 06:50:33.498817	2025-08-31 06:50:33.498817
279	99f4badf-782a-4a50-9c10-df939cdc84cf	2025-08-31 06:54:10.506094	2025-08-31 06:54:10.506094
280	5fa3b0b6-d69d-4207-8b25-af1a3c010a28	2025-08-31 06:57:26.405082	2025-08-31 06:57:26.405082
281	5d2a5699-9d83-4a2c-8df2-d7ba0d952622	2025-08-31 06:57:40.954066	2025-08-31 06:57:40.954066
282	6949a80e-ac63-417b-a608-f4cd7115fd38	2025-08-31 07:00:29.429781	2025-08-31 07:00:29.429781
283	cf5d30ca-cb5f-4068-8119-2bbeda81f299	2025-08-31 07:09:56.342073	2025-08-31 07:09:56.342073
284	9413344d-3ba5-4068-a06c-18c835daa645	2025-08-31 07:11:44.910947	2025-08-31 07:11:44.910947
285	7d6093f6-b503-4bc3-9bcc-de71523d9cba	2025-08-31 07:17:44.961104	2025-08-31 07:17:44.961104
286	743db1bb-5677-496f-96d6-aa4071ba2543	2025-08-31 07:18:23.422657	2025-08-31 07:18:23.422657
287	6e42249f-5cdc-4b8c-aafa-135d77d37139	2025-08-31 07:19:01.88544	2025-08-31 07:19:01.88544
288	26ce7217-6a39-489f-a18a-f74cf0b1f0b2	2025-08-31 07:20:48.41447	2025-08-31 07:20:48.41447
289	70617cc0-3e7e-43c9-bbcc-d3b79ee62447	2025-08-31 07:22:37.639194	2025-08-31 07:22:37.639194
290	3ffbe23d-7fa5-47a4-b7dd-1d1bdbcd9b4b	2025-08-31 07:28:52.514357	2025-08-31 07:28:52.514357
291	ff5d3cb5-a53e-41db-81a6-2f2a5cc7038e	2025-08-31 07:29:44.658301	2025-08-31 07:29:44.658301
292	4fff6772-56d3-453c-90b0-9458b0616909	2025-08-31 07:38:31.652673	2025-08-31 07:38:31.652673
293	c984d009-13d9-426f-abd2-368cbcbe9f72	2025-08-31 07:40:27.082021	2025-08-31 07:40:27.082021
294	cbbfb62a-6ebf-418d-8974-b7f571c0d0cd	2025-08-31 07:53:24.528394	2025-08-31 07:53:24.528394
295	69594a4a-f0a1-4846-b210-7366ad32944c	2025-08-31 08:01:05.240733	2025-08-31 08:01:05.240733
296	bf5dc7b0-abc8-4d83-9c72-84522a39b693	2025-08-31 08:02:14.659397	2025-08-31 08:02:14.659397
297	ed8f03a5-9b45-4523-8e63-2b23490f759e	2025-08-31 08:06:21.874875	2025-08-31 08:06:21.874875
298	d68d5f6a-aade-47b0-8cf3-da0e7a4ee57b	2025-08-31 08:09:19.275842	2025-08-31 08:09:19.275842
299	d4ac3908-4cb1-44e3-aa4a-18bcec7a51b3	2025-08-31 08:19:46.21034	2025-08-31 08:19:46.21034
300	c0e9a12f-ce85-4a11-be0f-df1c0fdd4a17	2025-08-31 08:21:42.369313	2025-08-31 08:21:42.369313
301	a3d154b7-c086-49c5-bf57-eceeb77cffaa	2025-08-31 08:25:13.714486	2025-08-31 08:25:13.714486
302	51869e5b-20a4-41ef-bfae-64c0a0b35825	2025-08-31 08:27:16.737964	2025-08-31 08:27:16.737964
303	489d88f7-e801-4df9-972c-08217dc390ab	2025-08-31 08:56:28.231701	2025-08-31 08:56:28.231701
304	9e9609f2-cca1-4976-951e-b5759b9ae30f	2025-08-31 08:58:16.318063	2025-08-31 08:58:16.318063
305	6b729201-8024-4300-bf52-e356582d6e9a	2025-08-31 09:21:28.022855	2025-08-31 09:21:28.022855
306	beec6a78-edda-47bc-aef7-a5624f37eccc	2025-08-31 09:29:26.486143	2025-08-31 09:29:26.486143
307	d5741578-d94c-4721-83e3-f71edc5db973	2025-08-31 13:13:26.16602	2025-08-31 13:13:26.16602
308	205bf943-aa18-46a8-afd0-3600eae417c5	2025-08-31 16:59:56.933836	2025-08-31 16:59:56.933836
310	809f8812-642b-407e-8581-281274086261	2025-09-01 14:51:48.531254	2025-09-01 14:51:48.531254
311	595640f9-3c5a-4330-b293-d9001d50e206	2025-09-01 22:26:28.460506	2025-09-01 22:26:28.460506
312	00b61be9-4fed-4c79-bf56-b6da3d8676be	2025-09-01 22:53:32.323424	2025-09-01 22:53:32.323424
313	214a7fce-0ee4-48a3-8f66-91ea776b02f3	2025-09-01 23:12:24.034436	2025-09-01 23:12:24.034436
314	e30d9cbc-fac6-4bb4-a7e6-28ea9829c778	2025-09-02 01:10:04.109161	2025-09-02 01:10:04.109161
315	d2290589-8bb6-4160-9ec5-09801c5bf5e7	2025-09-02 01:41:20.874039	2025-09-02 01:41:20.874039
316	0baf6a3c-9ba2-478d-87dc-f576a2fa9632	2025-09-02 01:41:23.70314	2025-09-02 01:41:23.70314
317	0e6da195-c8fd-4a6a-85d0-45e3efa777ad	2025-09-02 02:57:56.729257	2025-09-02 02:57:56.729257
318	678eb7ea-0cba-49c9-a083-63cf36f4fc0a	2025-09-02 07:01:36.247013	2025-09-02 07:01:36.247013
319	83c03752-5934-45c8-9e1c-d5c59148ce0d	2025-09-02 07:42:07.051084	2025-09-02 07:42:07.051084
320	b56e334b-0fcf-42e5-8d7f-3d714be93001	2025-09-02 07:43:16.928562	2025-09-02 07:43:16.928562
321	9f5f5470-0048-479a-9103-98d73a4267b0	2025-09-02 07:46:57.644912	2025-09-02 07:46:57.644912
322	e5fb8a5a-6566-496c-91bf-a6978ce78ba4	2025-09-02 07:47:01.849714	2025-09-02 07:47:01.849714
323	67b974b1-ae08-4897-8264-fa2cb0dee2f6	2025-09-02 08:02:07.248813	2025-09-02 08:02:07.248813
325	199a7945-5939-4b50-bdc8-bdfd59b87f18	2025-09-02 09:03:37.838636	2025-09-02 09:03:37.838636
326	2691f64d-39dc-4001-b16a-c4bab554eea7	2025-09-02 09:03:42.428602	2025-09-02 09:03:42.428602
324	dd58cd84-751b-453e-9110-9bc0aa36178e	2025-09-02 09:00:02.455784	2025-09-11 16:33:57.633
330	8da9c09c-44e6-40f7-913d-cdea7cc1be67	2025-09-02 10:52:48.894862	2025-09-02 10:52:48.894862
309	ff71a19d-c8dc-4151-8fe8-19c08d2874c1	2025-09-01 06:28:24.874685	2025-09-02 09:28:30.382
331	d890ad6f-31bb-4fcd-aad9-ca104a2cdcb4	2025-09-02 11:37:25.867992	2025-09-02 11:37:25.867992
332	ff8516c9-6448-45a2-9dd5-d64af9a4f40e	2025-09-02 15:02:43.561296	2025-09-02 15:02:43.561296
333	1b692d82-b963-4cc7-a85c-1ae1ce17f54b	2025-09-03 03:12:06.86811	2025-09-03 03:12:06.86811
334	fe36baf8-439f-49c0-b5d9-4c7a5e12a8e5	2025-09-03 06:44:02.753283	2025-09-03 06:44:02.753283
335	235c3575-de37-41bb-8fd9-45eb98ffb17d	2025-09-03 06:47:17.056843	2025-09-03 06:47:17.056843
336	aee222ee-977e-4034-81db-65b89974a9f8	2025-09-03 06:47:24.996969	2025-09-03 06:47:24.996969
327	16668bd1-3824-4f0b-977e-c1fa6e169814	2025-09-02 09:34:53.556118	2025-09-02 09:35:26.094
328	21570da5-c68c-4d3f-8720-f0db75653039	2025-09-02 10:06:50.143693	2025-09-02 10:06:50.143693
329	1f733dc2-6c63-4af1-bbb3-520a0e0ea7d1	2025-09-02 10:07:22.453691	2025-09-02 10:09:30.861
337	e22a9d34-50d5-48b6-bc65-f2b19aa4d1d4	2025-09-03 06:48:07.926635	2025-09-03 06:48:07.926635
338	e25de519-0925-483e-8e21-6ab99668260c	2025-09-03 07:58:47.402763	2025-09-03 07:58:47.402763
339	75f59141-388c-416f-8e30-e7633f1a26cc	2025-09-03 08:33:39.644088	2025-09-03 08:33:39.644088
340	0469baea-453f-4467-bae4-2220e9ddee66	2025-09-03 08:38:20.891884	2025-09-03 08:38:20.891884
341	758555b7-34d0-4d93-96fc-d7dd9b534ea0	2025-09-03 08:50:07.34126	2025-09-03 08:50:07.34126
342	8fc359ef-1235-4ee6-9fb0-73dc23dd3298	2025-09-03 08:51:17.998076	2025-09-03 08:51:17.998076
343	8d31eeab-10d1-4cb5-9696-90dae59b54b2	2025-09-03 08:51:18.167822	2025-09-03 08:51:18.167822
344	80c14d7e-0f58-4c58-a367-f81d997abd6f	2025-09-03 08:51:23.499817	2025-09-03 08:51:23.499817
231	45ddbe15-0f6d-45b5-a34c-3842c3c4ae4d	2025-08-30 18:45:49.403774	2025-09-12 03:49:04.328
345	6ddcf0f1-05e8-48db-8413-0887e713832f	2025-09-03 08:55:52.611025	2025-09-03 08:55:52.611025
346	ecfcff21-9e16-48f6-ad70-665f3a750ab2	2025-09-03 09:07:56.780482	2025-09-03 09:07:56.780482
347	1d7670f9-4541-4c28-9f21-777e1db359c5	2025-09-03 09:29:41.898266	2025-09-03 09:29:41.898266
348	fca5695d-0cbb-4f2a-8f68-969d4e49914e	2025-09-03 09:32:40.610517	2025-09-03 09:32:40.610517
349	3b786ca5-5c36-4964-9bb9-efc256e16770	2025-09-03 11:49:44.613791	2025-09-03 11:49:44.613791
350	0ef612b4-7267-4f82-8f41-71800b7ba8e5	2025-09-03 11:55:56.320146	2025-09-03 11:55:56.320146
351	9b053e4c-fcfe-4855-9e30-60a323f8cb1f	2025-09-03 12:40:47.75387	2025-09-03 12:40:47.75387
352	e167484b-92c8-4f5e-b35e-1a88e1ef285f	2025-09-03 14:22:43.177243	2025-09-03 14:22:43.177243
353	e79c1a72-16e1-4b8d-a0ee-5bf851dc88be	2025-09-03 14:59:57.205316	2025-09-03 14:59:57.205316
354	6d8aed01-6922-4a64-b55f-4e30c553bdb6	2025-09-03 14:59:59.279125	2025-09-03 14:59:59.279125
355	92659ca8-adfe-4f70-bd96-77474a30b2c3	2025-09-03 15:01:08.0764	2025-09-03 15:01:08.0764
356	e4cf8349-21c7-46c3-a1ad-ce49261517e2	2025-09-03 15:04:04.310688	2025-09-03 15:04:04.310688
357	f483729b-15ec-4e2f-98d7-7534848c395f	2025-09-03 15:08:02.546517	2025-09-03 15:08:02.546517
358	749c8016-b337-45ba-96e9-7b91597f69f2	2025-09-03 15:08:34.393298	2025-09-03 15:08:34.393298
359	4e9a5711-1de0-4659-9940-d6883fec775f	2025-09-03 15:08:49.660428	2025-09-03 15:08:49.660428
360	6cdff59e-64f1-4fbb-9dc0-01d795270bad	2025-09-03 15:08:49.730818	2025-09-03 15:08:49.730818
361	4df34f84-53ed-4603-b8ba-f172d615c49d	2025-09-03 15:09:27.444874	2025-09-03 15:09:27.444874
362	d64f54c1-988f-42f7-acb9-9e11c77afc16	2025-09-03 15:09:33.437988	2025-09-03 15:09:33.437988
363	211ef1ba-7f80-479a-920c-1ed43f5c8a40	2025-09-03 15:11:36.234906	2025-09-03 15:11:36.234906
364	6b08c6ac-69a4-449d-8525-6e5edddde32c	2025-09-03 15:14:42.26686	2025-09-03 15:14:42.26686
365	a36dadd6-05b5-4bdc-818d-818355cd3873	2025-09-03 15:14:57.832215	2025-09-03 15:14:57.832215
366	1e3762f2-c7b1-4ad4-8594-097c19d04a3f	2025-09-03 15:15:11.069828	2025-09-03 15:15:11.069828
367	17f669a5-c049-4a8c-91a7-7f72da73d767	2025-09-03 15:16:04.491649	2025-09-03 15:16:04.491649
368	6ecd77be-b2bb-4d8c-a4fd-c6b96df42ad1	2025-09-03 15:18:18.628528	2025-09-03 15:18:18.628528
369	0581dcfe-8f9e-4667-a35c-bfe4508370c8	2025-09-03 15:18:22.683212	2025-09-03 15:18:22.683212
370	7a3930cb-d91c-4c4e-848b-5d9239e8a45e	2025-09-03 15:19:34.486532	2025-09-03 15:19:34.486532
371	d4f5d2b6-91eb-4745-80a4-9c27a72e2ccc	2025-09-03 15:19:55.908938	2025-09-03 15:19:55.908938
372	bae0bcdb-c7a7-47c5-b83c-f2f61713a684	2025-09-03 15:21:02.03777	2025-09-03 15:21:02.03777
373	980a3a76-0a08-4c7c-bf22-3227cf69e6d6	2025-09-03 15:21:24.377809	2025-09-03 15:21:24.377809
374	cd1a4ae6-561b-4709-993a-8af678dbc6d3	2025-09-03 15:21:40.9589	2025-09-03 15:21:40.9589
375	16c07988-b4d5-4464-a171-bd1094489663	2025-09-03 15:21:42.020043	2025-09-03 15:21:42.020043
376	56fc7c5f-df14-41c9-add6-bdd2390d706c	2025-09-03 15:22:23.06964	2025-09-03 15:22:23.06964
377	8b8983e7-4191-4988-8643-f9f72f896502	2025-09-03 15:22:58.270542	2025-09-03 15:22:58.270542
378	fb133021-c9ed-47e7-a2ed-bff02a454401	2025-09-03 15:23:05.585793	2025-09-03 15:23:05.585793
379	782716b7-b924-43a1-9e1e-adb71a8e80a7	2025-09-03 15:23:13.77032	2025-09-03 15:23:13.77032
380	34700e9b-6ec6-4655-968c-94593d64230f	2025-09-03 15:23:16.456777	2025-09-03 15:23:16.456777
381	6288cac8-1377-49af-83ad-dc0330af2626	2025-09-03 15:24:10.709466	2025-09-03 15:24:10.709466
382	c7fe6e4f-be39-4bfb-842c-3f7f6571925a	2025-09-03 15:26:26.292001	2025-09-03 15:26:26.292001
383	8ff6e498-e4ce-4b3c-ae78-c10e292f0085	2025-09-03 15:35:23.155647	2025-09-03 15:35:23.155647
384	af0ccdcd-5954-419c-984a-dded8312c341	2025-09-03 15:35:25.175719	2025-09-03 15:35:25.175719
385	1ea56545-9cd1-44c8-b946-00344deb36f6	2025-09-03 15:35:25.232607	2025-09-03 15:35:25.232607
386	294a87ad-57f4-4191-891d-5af45a5f643a	2025-09-03 15:35:26.950949	2025-09-03 15:35:26.950949
387	3baf3083-6772-4518-bef2-f02b8b9ded87	2025-09-03 15:35:42.565697	2025-09-03 15:35:42.565697
388	3581163b-b8db-4db1-af3b-1209f5785eca	2025-09-03 15:36:00.251549	2025-09-03 15:36:00.251549
389	c3ffd4b3-6ea6-4dcc-95c6-678b894e4409	2025-09-03 15:36:27.419245	2025-09-03 15:36:27.419245
390	dcaee5f6-75a7-4418-b1c9-9bdf3179f2d5	2025-09-03 15:37:16.85242	2025-09-03 15:37:16.85242
391	3984ad39-1448-4c6e-ba2f-3a4e464014cc	2025-09-03 15:39:56.010995	2025-09-03 15:39:56.010995
392	cb2238b2-4a17-443e-8484-6e9681d05d23	2025-09-03 15:40:40.890848	2025-09-03 15:40:40.890848
393	177b029b-9a29-4e25-8a87-9373634f46fc	2025-09-03 15:59:48.989173	2025-09-03 15:59:48.989173
394	764898a5-200f-464f-a09e-742f5f0d4ac2	2025-09-03 16:00:25.681461	2025-09-03 16:00:25.681461
395	05cbf303-4246-45a9-8151-f18525f44acc	2025-09-03 16:00:27.766219	2025-09-03 16:00:27.766219
396	465a7d30-f047-4363-9af5-3b6a2350d185	2025-09-03 16:04:22.147961	2025-09-03 16:04:22.147961
397	708961a0-199e-4966-b8c0-0e064f145d57	2025-09-03 16:04:57.791568	2025-09-03 16:04:57.791568
398	5754f377-eed4-4745-b1f4-2c602ee04a14	2025-09-03 16:08:57.077385	2025-09-03 16:08:57.077385
399	9d2526e4-02ba-493e-b861-fa9d9e19a77a	2025-09-03 16:16:35.235544	2025-09-03 16:16:35.235544
400	d6af9bb8-5671-4c44-8943-f1d121a7475c	2025-09-03 16:16:38.420549	2025-09-03 16:16:38.420549
401	2b8c4a2e-b6d1-49b9-83b7-c278b3befd62	2025-09-03 16:16:46.254369	2025-09-03 16:16:46.254369
402	457021ba-43aa-4ab9-88b9-e0edbeeb3dcf	2025-09-03 16:16:54.593675	2025-09-03 16:16:54.593675
403	e92febf7-9307-4eda-8e2e-19d638ce1b36	2025-09-03 16:17:14.599312	2025-09-03 16:17:14.599312
404	c897efec-9307-4e0f-ae5b-0d40f2981f74	2025-09-03 16:22:41.701253	2025-09-03 16:22:41.701253
405	5bec504c-f0e5-41f1-9667-fb554b592f6c	2025-09-03 16:29:40.469429	2025-09-03 16:29:40.469429
406	d9fa46b2-638b-4dc5-b625-c257c1cc7772	2025-09-03 16:35:24.9017	2025-09-03 16:35:24.9017
407	e90b543a-43c1-42d6-bafb-285710ec7a35	2025-09-03 16:36:06.11199	2025-09-03 16:36:06.11199
408	7cc270a4-a3a3-407c-9293-6fe6505804bb	2025-09-03 16:54:50.436961	2025-09-03 16:54:50.436961
409	34c3d690-5d86-4292-a44b-893ace7c0a0b	2025-09-03 17:05:45.134228	2025-09-03 17:05:45.134228
410	a1652cc6-963b-4167-b940-6cceebab71f7	2025-09-03 17:37:48.063844	2025-09-03 17:37:48.063844
411	911615bc-b2f3-4d2d-a431-907cb0cc29c3	2025-09-03 17:46:51.769944	2025-09-03 17:46:51.769944
412	fc87c19f-68a6-42b0-8825-a7531694aa40	2025-09-03 17:47:08.396853	2025-09-03 17:47:08.396853
413	f845d24b-12e0-4e32-9c5b-3a33b789c411	2025-09-03 18:40:02.060153	2025-09-03 18:40:02.060153
414	589c56ef-5489-481f-9ff0-2c3db285e497	2025-09-03 22:37:47.611837	2025-09-03 22:37:47.611837
415	72d0608c-c8ff-4a92-926e-aea57ea4639c	2025-09-03 23:17:28.313859	2025-09-03 23:17:28.313859
416	cadea49d-a940-4204-b269-5f70cbd587d2	2025-09-03 23:18:48.409806	2025-09-03 23:18:48.409806
417	5526bbc9-a5a6-4eb5-b3ce-3ea91ca263b3	2025-09-03 23:41:25.720785	2025-09-03 23:41:25.720785
418	847ed88f-7ea9-4c13-a82f-178cc4f4a16f	2025-09-04 09:06:29.423663	2025-09-04 09:06:29.423663
419	5985a09d-52bb-42d0-bc63-2845e4d75307	2025-09-04 09:51:16.826452	2025-09-04 09:51:16.826452
420	084ed3c9-56ca-42c1-8bef-5d222038326a	2025-09-04 09:51:17.36899	2025-09-04 09:51:17.36899
421	562ea391-eec7-4e24-b1d9-794657b90e87	2025-09-04 09:51:17.605319	2025-09-04 09:51:17.605319
422	da971fbc-78f2-4c23-b269-ae7652209059	2025-09-04 09:52:34.72157	2025-09-04 09:52:34.72157
426	84a12981-536c-4867-851d-969324d718af	2025-09-04 11:52:57.801644	2025-09-04 11:52:57.801644
427	576f7890-5321-4912-9b89-725fc7a55de0	2025-09-04 12:22:06.54469	2025-09-04 12:22:06.54469
423	bd56d410-b206-4a59-946e-d17d520e25dd	2025-09-04 09:54:36.784412	2025-09-04 09:54:36.784412
424	e8aa1820-ffcf-49ca-9df8-42d7eab06916	2025-09-04 10:02:05.868157	2025-09-04 10:02:05.868157
425	647512c2-aae4-47ae-a683-a354c59369e0	2025-09-04 11:48:47.001314	2025-09-04 11:48:47.001314
428	971adc0c-a143-4247-9d67-8cd074954663	2025-09-04 14:56:15.617623	2025-09-04 14:56:15.617623
429	d1101236-1a1e-4617-a126-01ca85546f4d	2025-09-04 15:52:48.710163	2025-09-04 15:52:48.710163
430	7f9c09e7-9aa5-4062-b0e9-9ac78d6daf0a	2025-09-04 16:03:17.912229	2025-09-04 16:03:17.912229
431	c0417728-d810-4a04-a93c-e4c7cadade9d	2025-09-04 17:10:19.511286	2025-09-04 17:10:19.511286
432	298b891b-89b5-4f58-8039-6f75acbfd9a3	2025-09-04 17:10:24.423851	2025-09-04 17:10:24.423851
433	248da22e-69d0-41c8-ae95-24cd8b6d4614	2025-09-04 17:10:28.426946	2025-09-04 17:10:28.426946
434	6f420c64-0d38-4162-a1c3-b8e7e4d43c77	2025-09-04 17:14:28.359376	2025-09-04 17:14:28.359376
435	e5aa2a78-822c-4f7d-8c30-aed3c16f3ab7	2025-09-04 17:57:51.480702	2025-09-04 17:57:51.480702
436	02d64e54-018a-4522-ab7c-e522ed67c075	2025-09-04 18:40:25.46775	2025-09-04 18:40:25.46775
437	afbd863e-52ea-48ef-9324-5a2a5c21886b	2025-09-04 19:34:38.025325	2025-09-04 19:34:38.025325
438	f1f49d2d-d93e-4fe7-ab45-b69c62a71c64	2025-09-04 19:34:56.623928	2025-09-04 19:34:56.623928
439	fd5e9385-1c8c-41bb-9065-dbcb061c9434	2025-09-04 20:29:04.874605	2025-09-04 20:29:04.874605
440	2c8c2df0-44d3-43b3-962d-710e922b1e47	2025-09-04 21:45:56.450028	2025-09-04 21:45:56.450028
441	d5936055-c48c-4dd6-ac7e-0a108e743c56	2025-09-04 23:01:51.442995	2025-09-04 23:01:51.442995
442	80c26557-7f09-4ec9-9368-977d7b277dd6	2025-09-05 02:08:27.785982	2025-09-05 02:08:27.785982
443	fbf1b32f-cd8a-4fc9-8fde-7608ff34c19f	2025-09-05 02:19:02.060353	2025-09-05 02:19:02.060353
444	527252c2-f1e4-49c7-8102-8944cb62282c	2025-09-05 03:24:28.367651	2025-09-05 03:24:28.367651
445	786fdbf1-dbd7-4286-a2a7-a0e45afcacf0	2025-09-05 07:41:39.761453	2025-09-05 07:41:39.761453
446	0e064d59-7f9d-4f30-8293-ff30e399d79d	2025-09-05 13:48:12.73481	2025-09-05 13:48:12.73481
447	24b85bf1-ef1e-411f-8161-7d6dae1c1407	2025-09-05 16:37:02.715711	2025-09-05 16:37:02.715711
448	edffa5a3-5b4a-41ed-b049-cc5a3cd6cd41	2025-09-05 16:48:31.469209	2025-09-05 16:48:31.469209
449	b09beb7e-1659-482c-94e0-e84f00b0bfb0	2025-09-05 23:40:03.847663	2025-09-05 23:40:03.847663
450	1de9d54f-fdbc-459e-9e90-7cea5cb522e7	2025-09-05 23:57:07.506114	2025-09-05 23:57:07.506114
451	cd22d618-7440-440e-857e-b2c08bb99418	2025-09-06 00:08:12.212262	2025-09-06 00:08:12.212262
452	eb0b4515-45e4-4a91-8f05-26b573965db6	2025-09-06 00:26:53.035764	2025-09-06 00:26:53.035764
514	aee35489-19dd-4b74-a2e0-c1c88298abc2	2025-09-10 16:53:22.903314	2025-09-10 16:53:22.903314
453	a45aa4d5-f5b3-4fef-97fa-32ab40a9fa64	2025-09-06 12:12:02.622355	2025-09-06 12:12:02.622355
454	7b3022fb-7dfc-457f-87b3-53c546056da0	2025-09-06 12:31:20.539778	2025-09-06 12:31:20.539778
455	ee87e55a-fb65-45f0-866e-c7264c4f8b2b	2025-09-07 15:02:21.796932	2025-09-07 15:02:21.796932
456	186a211b-12b2-4b17-a050-1a6bdb9574b4	2025-09-08 08:18:13.491257	2025-09-08 08:18:13.491257
457	1298eff8-ea8a-4197-bcb0-e78b222d3b34	2025-09-08 10:09:29.714087	2025-09-08 10:09:29.714087
458	4eec9aed-ae30-4e80-b484-5c04cada5bc9	2025-09-08 10:09:29.945136	2025-09-08 10:09:29.945136
459	b5f0f1f4-6c91-4fa9-9142-aa06ae9186af	2025-09-08 13:04:01.937323	2025-09-08 13:04:01.937323
460	9af0409a-15ac-41a5-8392-ce8bd6e0a10a	2025-09-08 15:14:52.828248	2025-09-08 15:14:52.828248
461	d6412b9d-04b4-4d2b-ad9a-e22f7f4b665b	2025-09-08 16:28:45.78357	2025-09-08 16:28:45.78357
462	9871ce39-a41c-46ae-93fb-c9cf4d063569	2025-09-08 16:41:51.936844	2025-09-08 16:41:51.936844
463	1ef7fdc4-2b1c-4ef2-8bc0-3ac0b04e9002	2025-09-08 20:21:34.999859	2025-09-08 20:21:34.999859
464	528073aa-f9bf-48c1-b9e8-f1050237c99b	2025-09-08 20:23:16.591263	2025-09-08 20:23:16.591263
465	2d090fb1-6804-4e5c-9bad-145536728014	2025-09-08 21:41:19.364492	2025-09-08 21:41:19.364492
466	211e74cd-77af-4a05-88ca-ece391d4d88d	2025-09-09 05:29:05.457605	2025-09-09 05:29:05.457605
467	abb066d7-1511-4d56-9a72-dc5bfe87be29	2025-09-09 05:59:08.809459	2025-09-09 05:59:08.809459
468	5c23f117-6e7b-475f-9261-4acd35463f85	2025-09-09 06:42:50.452472	2025-09-09 06:42:50.452472
469	ce3d9886-0d42-48b2-86d6-ccb028bcae74	2025-09-09 06:46:34.129569	2025-09-09 06:46:34.129569
470	f8fbaa0b-1575-403e-8080-26e463d82b8c	2025-09-09 08:14:55.099575	2025-09-09 08:14:55.099575
471	40afeaa3-c90a-4632-aa15-e5846e0dbc2d	2025-09-09 22:55:40.377393	2025-09-09 22:55:40.377393
472	cb912935-3e65-4fb0-9ebf-8caee18b1382	2025-09-10 00:20:43.186452	2025-09-10 00:20:43.186452
473	ac23d0c2-e7ff-46af-a8fe-84b17f419cc7	2025-09-10 00:49:59.267223	2025-09-10 00:49:59.267223
474	a6710ce1-0621-4c63-8e66-3bd10f3f8c16	2025-09-10 02:50:27.827453	2025-09-10 02:50:27.827453
475	a11f59f1-3d9c-4e53-ad7f-349d0537cf04	2025-09-10 04:15:35.042576	2025-09-10 04:15:35.042576
476	1f7d11c9-329b-4c74-8108-5ecdde0bc332	2025-09-10 07:10:36.918718	2025-09-10 07:10:36.918718
477	e4ca580b-7853-4ffc-bf22-8fd74e28ca0e	2025-09-10 07:49:42.271385	2025-09-10 07:49:42.271385
478	8b608c74-6a3a-4607-964d-6f093337cb0a	2025-09-10 09:01:10.259124	2025-09-10 09:01:10.259124
479	531e3b11-7644-4049-a46c-e52e67f6dd22	2025-09-10 09:08:01.214796	2025-09-10 09:08:01.214796
480	41bddd04-1366-46c1-bc02-140bcb85e0da	2025-09-10 10:35:27.199384	2025-09-10 10:35:27.199384
481	492e5a64-77bd-497e-b69b-fd6361c8b2be	2025-09-10 12:53:17.973595	2025-09-10 12:53:17.973595
482	fcaa6afb-a64c-470f-b253-b0ebc7d6f55c	2025-09-10 13:05:50.77741	2025-09-10 13:05:50.77741
483	b9117b0f-be9c-4198-84fc-02b1b2c18c9b	2025-09-10 13:12:46.436661	2025-09-10 13:12:46.436661
484	97c846b2-19c6-44c9-b543-170af5a008a1	2025-09-10 13:14:22.57667	2025-09-10 13:14:22.57667
485	b7fe928d-3125-4445-9e43-93518c728414	2025-09-10 13:27:10.973352	2025-09-10 13:27:10.973352
486	2272ee2c-c989-4897-97fc-0c99deb57be4	2025-09-10 13:55:47.316368	2025-09-10 13:55:47.316368
487	979e4c65-4a45-4918-93e8-76ed38edb5dc	2025-09-10 14:00:50.179496	2025-09-10 14:00:50.179496
488	8f750f53-dbd5-4dd0-a921-6f9c58dfb93b	2025-09-10 14:06:45.679468	2025-09-10 14:06:45.679468
489	c2e75b0d-655a-418c-ac7f-c76461f407d4	2025-09-10 14:07:45.353901	2025-09-10 14:07:45.353901
490	b64be78a-6fea-452a-828b-6720dc069c12	2025-09-10 14:16:27.218442	2025-09-10 14:16:27.218442
491	75699f1a-c17c-4c65-b08f-fff3af301b61	2025-09-10 14:22:59.893926	2025-09-10 14:22:59.893926
492	cf77e711-dec4-4a8f-bede-d1a47ccd2949	2025-09-10 14:45:07.98368	2025-09-10 14:45:07.98368
493	b8414a11-0682-4b67-a45f-cb325bb016e6	2025-09-10 14:51:40.893859	2025-09-10 14:51:40.893859
494	2613896d-70d2-48f4-8911-d805d7fd8bb9	2025-09-10 14:58:12.234912	2025-09-10 14:58:12.234912
495	cb284560-5f7c-4f5b-8fe1-ff88940b56fc	2025-09-10 15:00:43.181566	2025-09-10 15:00:43.181566
496	3abf3344-ef70-4428-ad7e-7353b48902bb	2025-09-10 15:03:34.201634	2025-09-10 15:03:34.201634
497	fd92a762-4daf-4afb-ab79-836cc56876f0	2025-09-10 15:16:30.741586	2025-09-10 15:16:30.741586
498	722fa059-4061-4b93-81fc-c834e5a8e69c	2025-09-10 15:17:35.712192	2025-09-10 15:17:35.712192
499	495cd702-e7ab-418f-8a11-64b59c971492	2025-09-10 15:29:03.218104	2025-09-10 15:29:03.218104
500	1a457bc6-79bc-416c-b87d-913a8921ca0b	2025-09-10 15:33:35.246043	2025-09-10 15:33:35.246043
501	ece77cea-ced9-4881-8a99-b003fdf606e7	2025-09-10 15:35:31.459839	2025-09-10 15:35:31.459839
502	b65f4c64-1365-4e80-8a8d-27c3697530a1	2025-09-10 15:48:22.862386	2025-09-10 15:48:22.862386
503	60892235-aa06-40f9-b730-9a8b41e989d3	2025-09-10 15:56:01.546083	2025-09-10 15:56:01.546083
504	6283ace6-3c2b-4f03-a574-fc9aa5efbabf	2025-09-10 15:59:07.639949	2025-09-10 15:59:07.639949
505	9faf6fc5-8454-452f-a2c1-6df92a0e462b	2025-09-10 16:01:45.897561	2025-09-10 16:01:45.897561
506	ff82d06e-ab54-456e-b04f-52122ca9fcf9	2025-09-10 16:05:15.007557	2025-09-10 16:05:15.007557
507	b62cb467-f267-4959-bfd6-26a7dc35a1eb	2025-09-10 16:07:34.852432	2025-09-10 16:07:34.852432
508	b999e00f-65cb-4b89-9d12-e14cf7c770b4	2025-09-10 16:11:42.527535	2025-09-10 16:11:42.527535
509	bbda128d-21f7-4d7c-8b4c-b981582d4558	2025-09-10 16:12:16.373263	2025-09-10 16:12:16.373263
510	f56ed33e-7d68-4de7-9687-269b314df5bd	2025-09-10 16:16:07.877122	2025-09-10 16:16:07.877122
511	ad191006-2fde-4502-a3cb-913434c28c93	2025-09-10 16:18:34.581763	2025-09-10 16:18:34.581763
512	88ab9a26-67b8-43fd-bd2a-a9808f318b1a	2025-09-10 16:27:10.799734	2025-09-10 16:27:10.799734
513	45863b12-4376-486b-8eee-4b80a85936bb	2025-09-10 16:34:42.675726	2025-09-10 16:34:42.675726
515	ef4561aa-30bb-452d-9647-e5da527d8e2c	2025-09-10 16:55:18.099312	2025-09-10 16:55:18.099312
516	dcace953-48ee-4330-bdb5-38eefbcb4058	2025-09-10 17:12:18.29927	2025-09-10 17:12:18.29927
517	fe4a1c75-d773-4bfc-823c-5a57cb025b52	2025-09-10 17:13:21.07219	2025-09-10 17:13:21.07219
518	81d5eca5-2387-4dc2-8ecb-19314f642569	2025-09-10 17:24:24.715565	2025-09-10 17:24:24.715565
519	ab4254a5-685f-4376-9d77-2b191b1fb157	2025-09-10 17:45:52.157568	2025-09-10 17:45:52.157568
520	add35ac7-035b-4cff-a141-6a48c4347584	2025-09-10 18:00:48.710726	2025-09-10 18:00:48.710726
521	ffb256f4-2605-4b97-98c8-613a0c4c6b43	2025-09-10 18:02:59.624795	2025-09-10 18:02:59.624795
522	076ca0eb-96a7-4921-bcea-90fd146de80d	2025-09-10 18:04:38.279101	2025-09-10 18:04:38.279101
523	10675036-ccff-486e-9005-13ab2bf321d4	2025-09-10 18:09:30.334472	2025-09-10 18:09:30.334472
524	3cc3d7f4-16a7-4398-85ce-b8779ae7d74d	2025-09-10 18:44:15.556449	2025-09-10 18:44:15.556449
525	4daa6835-c7d7-4aaa-87f6-841be22cead1	2025-09-10 18:45:07.290117	2025-09-10 18:45:07.290117
526	accf22f5-348e-46a5-912c-45370b722b0a	2025-09-10 19:08:23.099455	2025-09-10 19:08:23.099455
527	e4979a11-e8fe-47c4-8f93-5f747e41d128	2025-09-10 19:10:05.55736	2025-09-10 19:10:05.55736
528	44506fe3-620b-41f4-aef9-7b4138323f03	2025-09-10 19:19:05.554521	2025-09-10 19:19:05.554521
529	57104a98-8cf7-4240-8f40-c5515899f248	2025-09-10 19:28:42.721469	2025-09-10 19:28:42.721469
530	9bb6ea5f-a274-4f7a-a315-53b11c87d7fb	2025-09-10 19:29:19.329449	2025-09-10 19:29:19.329449
531	3842d6b1-8751-4f2b-b384-11c2b4f562fb	2025-09-10 19:32:48.32204	2025-09-10 19:32:48.32204
532	89c9f5c3-1fbc-480a-8212-910530be500f	2025-09-10 19:52:48.206968	2025-09-10 19:52:48.206968
533	15e4d434-1644-4cb6-9f27-44b829dee6a0	2025-09-10 20:13:07.466866	2025-09-10 20:13:07.466866
534	47f7c784-ccf8-48c3-93aa-2f2109c00b0c	2025-09-10 20:22:35.109322	2025-09-10 20:22:35.109322
535	aba9967d-4304-409e-b187-34020f62a82e	2025-09-10 20:22:40.590038	2025-09-10 20:22:40.590038
536	bff302ff-ccbe-4d12-b6c7-0be7e2e4660d	2025-09-10 20:28:19.675962	2025-09-10 20:28:19.675962
537	ebf7c66c-bbd2-4410-b526-b6716201fd8b	2025-09-10 20:50:37.228884	2025-09-10 20:50:37.228884
538	659b1e21-678a-4e27-bc7f-123e0103b98d	2025-09-10 21:34:29.784487	2025-09-10 21:34:29.784487
539	c449b793-a41a-422f-a5a2-ac3bcfb21616	2025-09-10 22:58:43.574473	2025-09-10 22:58:43.574473
540	0bbaa936-8958-42d6-937c-25ef52a27dd4	2025-09-10 23:14:41.293136	2025-09-10 23:14:41.293136
541	1226c088-dbee-430d-add1-0d6d106464d7	2025-09-10 23:47:40.813641	2025-09-10 23:47:40.813641
542	d3af3b3a-6b9a-42dd-a0e9-49f3c7b0a559	2025-09-10 23:54:21.811721	2025-09-10 23:54:21.811721
543	8c70ae3c-a238-444e-8ff7-a53d96f1dc29	2025-09-10 23:59:25.998495	2025-09-10 23:59:25.998495
544	b3f3ef98-7dd2-434c-a4d4-6d812f03f659	2025-09-11 00:32:54.363967	2025-09-11 00:32:54.363967
545	22e46364-d90e-4867-8c4e-07f666dab4f1	2025-09-11 00:57:03.67796	2025-09-11 00:57:03.67796
546	c09eaa13-944e-4771-93aa-8f328b5b496d	2025-09-11 01:08:00.92038	2025-09-11 01:08:00.92038
547	13d88ea4-d36e-48b8-a673-1ad632e8a07d	2025-09-11 02:26:33.276152	2025-09-11 02:26:33.276152
548	966c89df-35bf-4398-96c8-80f58f71c8aa	2025-09-11 03:21:48.886018	2025-09-11 03:21:48.886018
549	2677bcce-a087-4b3c-a01c-84f12fc265fe	2025-09-11 03:51:32.483723	2025-09-11 03:51:32.483723
550	8287e2f0-1b9a-44fc-92b6-c7147f48a641	2025-09-11 04:18:43.902543	2025-09-11 04:18:43.902543
551	9dcf2234-e96a-4d5e-bcde-45171954259a	2025-09-11 04:53:16.160182	2025-09-11 04:53:16.160182
552	53a80749-eec0-496e-969f-8cd3ac52a59d	2025-09-11 05:02:01.511168	2025-09-11 05:02:01.511168
553	2a88b356-bed1-49d6-a1df-322132d0ef84	2025-09-11 05:02:09.238622	2025-09-11 05:02:09.238622
554	38f3aea8-eaff-4de2-80b0-96e7b106be1d	2025-09-11 05:05:13.809874	2025-09-11 05:05:13.809874
555	6c0f6a13-d857-4995-966e-2528640d0a43	2025-09-11 05:13:13.556113	2025-09-11 05:13:13.556113
556	f7ba1146-3c41-467d-bdca-a978eaaa9558	2025-09-11 05:13:35.498203	2025-09-11 05:13:35.498203
557	a961cc4f-cbca-4d7d-b57f-f5093382809b	2025-09-11 05:16:07.904911	2025-09-11 05:16:07.904911
558	da4964c0-1f4c-4e62-bff1-db09ee3f1b36	2025-09-11 05:28:02.341922	2025-09-11 05:28:02.341922
559	57a5a75a-a321-4605-8082-bf5370747a87	2025-09-11 05:40:15.421481	2025-09-11 05:40:15.421481
560	edf7bca9-9e75-4aef-9c2f-cc1a09353959	2025-09-11 05:41:47.907013	2025-09-11 05:41:47.907013
561	cca0eb2b-06bc-4f73-8631-e93864c3332d	2025-09-11 05:46:28.820707	2025-09-11 05:46:28.820707
562	7b58aee2-1bb7-40e0-b2f8-5968489d892d	2025-09-11 06:32:36.501137	2025-09-11 06:32:36.501137
563	a24fa473-b686-4570-9dc3-899d50b8c275	2025-09-11 06:41:07.558892	2025-09-11 06:41:07.558892
564	2dcb3588-051d-4716-8f76-96727f4ccc18	2025-09-11 06:42:56.418771	2025-09-11 06:42:56.418771
565	8059805f-cd3c-47f9-9144-83bb04ee0953	2025-09-11 06:48:25.958947	2025-09-11 06:48:25.958947
566	832b99ea-301f-45cd-8a76-cf3c66c974b6	2025-09-11 06:50:49.266882	2025-09-11 06:50:49.266882
567	111bb3f3-45c5-45bb-bfa6-4d24c2bfd65f	2025-09-11 06:57:58.557917	2025-09-11 06:57:58.557917
568	80c4cabf-c583-4a34-94f3-a0a2869cd07a	2025-09-11 06:59:13.09899	2025-09-11 06:59:13.09899
569	509f9886-29e6-4876-bb22-174985bca39b	2025-09-11 07:10:58.56216	2025-09-11 07:10:58.56216
570	b7224d6f-8597-457b-97c6-17b658f2be83	2025-09-11 07:27:06.416673	2025-09-11 07:27:06.416673
571	aa48649e-67c8-4e7e-9de5-8cdbde107bf8	2025-09-11 07:29:47.865942	2025-09-11 07:29:47.865942
572	fef70da7-3054-4de7-9f65-20b6c08d305a	2025-09-11 07:30:59.076434	2025-09-11 07:30:59.076434
573	67498573-6a2c-43cc-9125-cd74e0ac3559	2025-09-11 07:31:57.415971	2025-09-11 07:31:57.415971
574	f3b1e928-247c-4c7d-9a0c-cf00370e3385	2025-09-11 07:39:14.247348	2025-09-11 07:39:14.247348
575	66689bc0-ca0d-464d-975e-ee98f63573b5	2025-09-11 07:41:25.802276	2025-09-11 07:41:25.802276
576	3f423e68-7b48-469d-adb8-d21e829ab1fb	2025-09-11 07:44:09.304019	2025-09-11 07:44:09.304019
577	95ec5821-bd75-4b63-98bd-ed1ba5d64e19	2025-09-11 07:44:34.107064	2025-09-11 07:44:34.107064
578	ffac8181-ae7d-43c8-8fa6-2caa98966e98	2025-09-11 08:10:24.531382	2025-09-11 08:10:24.531382
579	ab165f3a-4622-46c2-8ca7-f761f7b36b47	2025-09-11 08:13:03.366228	2025-09-11 08:13:03.366228
580	a362136a-bd7c-4de2-9f18-6164344e69a5	2025-09-11 08:18:39.170292	2025-09-11 08:18:39.170292
581	d4ee24a8-c115-46b8-9e1d-8d286cfa4e0a	2025-09-11 08:56:35.279065	2025-09-11 08:56:35.279065
582	768c4d3c-8123-44aa-892e-b69cff0af707	2025-09-11 10:44:32.68468	2025-09-11 10:44:32.68468
583	3405014d-0150-4fdb-aafd-4091a969c775	2025-09-11 15:30:41.171849	2025-09-11 15:30:41.171849
584	4e03cfa1-76cd-48f4-97dc-38e42b3edba7	2025-09-11 16:30:30.676835	2025-09-11 16:30:30.676835
585	26c6c64c-aa99-4619-a4f2-334bf9f01c31	2025-09-12 02:41:54.413764	2025-09-12 02:41:54.413764
586	0d7c7689-a644-430d-800d-81c2185a6ede	2025-09-12 03:49:22.346296	2025-09-12 03:49:22.346296
600	78fd66b0-cd1e-47a2-b7e8-2d4683eff85b	2025-09-14 00:50:25.554581	2025-09-14 00:50:25.554581
601	94566145-564c-44c1-a5fd-97bbc9deb457	2025-09-14 00:51:59.208703	2025-09-14 00:51:59.208703
587	8bfc430c-1a40-457f-a126-f4dfda40063d	2025-09-12 13:23:54.67459	2025-09-12 13:23:54.67459
588	37a301ec-2148-40bb-a110-bbc9a09515aa	2025-09-12 15:54:38.439354	2025-09-12 15:54:38.439354
589	f3ac0e1d-1ef3-4ce4-9d1d-9c7f754a1ed0	2025-09-12 18:34:19.671853	2025-09-12 18:34:19.671853
590	3f31a6e0-2c29-4e31-b601-b80f37ed8591	2025-09-12 22:34:43.540663	2025-09-12 22:34:43.540663
591	9155ec5e-4355-499e-96bd-03f9546de61e	2025-09-13 02:26:11.304196	2025-09-13 02:26:11.304196
592	d73fe69a-3220-43e0-90b7-4ff60b523523	2025-09-13 05:19:50.770301	2025-09-13 05:19:50.770301
593	6737e0b6-646b-49a0-aa1c-c381ac86b2cc	2025-09-13 11:49:49.609778	2025-09-13 11:49:49.609778
594	0497768b-b56d-4f6b-95fd-0f635250748a	2025-09-13 12:07:40.855529	2025-09-13 12:07:40.855529
595	9d460e8b-3fff-4fc3-b9a1-c8405f66873f	2025-09-13 15:58:53.318721	2025-09-13 15:58:53.318721
596	5cd7ca16-fb1d-454b-bfd4-b7b099259589	2025-09-13 16:36:40.464101	2025-09-13 16:36:40.464101
597	aa7f10c6-b28d-469e-8f11-c6c805bde270	2025-09-13 16:42:33.861536	2025-09-13 16:42:33.861536
598	c915b751-a828-4111-9899-f74e9131ab7f	2025-09-13 21:12:34.728094	2025-09-13 21:12:34.728094
599	153c8e02-2e91-465e-9d2c-d7c2de689fa9	2025-09-14 00:18:02.681218	2025-09-14 00:18:02.681218
602	8c1575a2-113b-4705-aeaf-f7bcd8bbf54f	2025-09-14 02:55:53.246261	2025-09-14 02:55:53.246261
603	97ca76e3-e41c-43b5-88d8-ba9871acdc1d	2025-09-14 04:24:50.410823	2025-09-14 04:24:50.410823
604	320c6232-a80b-4361-9e4c-48e1e156b869	2025-09-14 05:45:07.181731	2025-09-14 05:45:07.181731
605	5f166f2d-4918-42b1-a20a-e0d665d30fa9	2025-09-14 06:20:08.606684	2025-09-14 06:20:08.606684
606	fbb6269e-ae29-46bc-83c6-69f080cc791b	2025-09-14 10:32:37.193225	2025-09-14 10:32:37.193225
607	c24ed9be-482e-4790-8c91-f5d6fc971cdb	2025-09-15 03:55:04.447862	2025-09-15 03:55:04.447862
608	d631d6cb-7508-471c-a5f7-90622af2f76f	2025-09-15 07:12:36.168092	2025-09-15 07:12:36.168092
609	814f34a4-9c6c-4543-8754-b7fb77f0b8b5	2025-09-15 07:51:11.246699	2025-09-15 07:51:11.246699
610	7b13dc44-1528-4947-b084-ab1eaa39ced2	2025-09-15 08:52:37.017454	2025-09-15 08:52:37.017454
611	e06252da-9460-4bef-a99e-2117d146d466	2025-09-15 14:22:07.55295	2025-09-15 14:22:07.55295
612	6a6b47ee-9c80-42b8-bc8a-0be84a5a837e	2025-09-15 14:42:29.905243	2025-09-15 14:42:29.905243
613	45f53f5b-710c-4f1f-955a-42915431b42f	2025-09-15 19:26:33.969271	2025-09-15 19:26:33.969271
614	3f35a8c2-3de1-45a1-a49a-281b65691313	2025-09-16 02:37:38.449761	2025-09-16 02:37:38.449761
615	90287be0-9775-4199-8d77-99ad882233da	2025-09-16 05:56:29.396254	2025-09-16 05:56:29.396254
616	e526500c-1c9a-4ed2-8228-8e1aaf7d268a	2025-09-16 15:38:57.322866	2025-09-16 15:38:57.322866
617	5f8c8102-8f8c-4168-8257-16d15b5df426	2025-09-17 02:59:06.924991	2025-09-17 02:59:06.924991
618	39ab03cc-8c29-46ef-b163-a5b268ee8a45	2025-09-17 04:28:45.753284	2025-09-17 04:28:45.753284
619	cb279215-1b4e-4a0b-a4fa-995bdb6b6c2c	2025-09-17 14:00:37.891079	2025-09-17 14:00:37.891079
620	0c000760-8560-4fc6-bd0f-f364d3a6e0b4	2025-09-17 14:51:16.508274	2025-09-17 14:51:16.508274
621	d177bc27-e86c-4b23-983c-df3adc599513	2025-09-17 17:22:58.02497	2025-09-17 17:22:58.02497
622	3c4bd73b-0dd3-46ba-a311-166cc85fffe3	2025-09-17 20:31:36.157858	2025-09-17 20:31:36.157858
623	6afe444a-80e6-4c6a-9fe8-36e22e05e099	2025-09-17 22:57:23.179257	2025-09-17 22:57:23.179257
624	1a5f2cdb-6d6c-4cc6-9561-f8e60810b387	2025-09-18 00:27:27.411732	2025-09-18 00:27:27.411732
625	e9c668be-cfd6-4636-8a16-df483e728e36	2025-09-18 00:32:57.10793	2025-09-18 00:32:57.10793
626	df58cac3-a9c8-464e-9135-61cf898ec18b	2025-09-18 01:25:27.699612	2025-09-18 01:25:27.699612
627	afc51cbc-58ec-4e08-84cf-01a5c5db9c8e	2025-09-18 01:25:30.598884	2025-09-18 01:25:30.598884
628	2b4556ab-8483-4783-95b3-db14a462f3c1	2025-09-18 01:55:44.08243	2025-09-18 01:55:44.08243
629	1e8fe764-2d6b-4f2a-b65b-ab94092b9555	2025-09-18 01:57:21.031027	2025-09-18 01:57:21.031027
630	c46db624-6180-4fe6-8180-0a28b5fe2448	2025-09-18 14:25:43.91232	2025-09-18 14:25:43.91232
631	57ec2890-5907-41f9-83cf-a4e29611b96c	2025-09-18 22:12:24.75438	2025-09-18 22:12:24.75438
632	dec338da-9b92-41e1-aad0-cae6815d2111	2025-09-19 06:07:22.577639	2025-09-19 06:07:22.577639
633	f71f940b-ed7a-40d5-962a-d5ed5d16155a	2025-09-19 10:01:24.045329	2025-09-19 10:01:24.045329
634	222cea31-9eec-460e-a025-63173e159282	2025-09-19 10:07:57.548766	2025-09-19 10:07:57.548766
635	4dab77f7-d014-4b23-88a9-792afa5ea96f	2025-09-19 10:08:31.163005	2025-09-19 10:08:31.163005
636	cb80a4cd-bf9d-46b4-b715-4ecfbd28b10f	2025-09-19 10:08:40.226832	2025-09-19 10:08:40.226832
637	9c9f8132-3d31-4c88-963b-8213e7f89114	2025-09-19 16:30:32.639525	2025-09-19 16:30:32.639525
638	abf47cb3-049c-43a9-a9f2-0e8322dbe93a	2025-09-19 18:00:37.125314	2025-09-19 18:00:37.125314
639	8145215e-7c91-471e-991f-6fdc7a7b9100	2025-09-20 01:52:03.302083	2025-09-20 01:52:03.302083
640	3536a2b0-fba0-410b-979d-d8e7e4c019d8	2025-09-20 02:17:09.8585	2025-09-20 02:17:09.8585
641	d88fcac6-e355-44f2-9bfc-169dab8af79d	2025-09-20 13:09:44.953096	2025-09-20 13:09:44.953096
642	417fb8d7-0d57-4d95-b194-1b8b5c14599d	2025-09-20 16:05:13.989875	2025-09-20 16:05:13.989875
643	179e4ce4-f2b3-4275-8963-e6c913f2e28d	2025-09-20 21:59:35.461235	2025-09-20 21:59:35.461235
644	b0e985ef-10dd-4693-918c-370670751c32	2025-09-21 02:36:22.734031	2025-09-21 02:36:22.734031
645	b2bd085e-6aed-480f-bcc4-3b6a19018dc8	2025-09-21 08:59:53.806874	2025-09-21 08:59:53.806874
646	33cfbbb9-c92a-4872-95a2-cde399373e85	2025-09-21 19:39:09.849041	2025-09-21 19:39:09.849041
647	bf61eb12-3bb8-449a-ae8f-ce55f5db7969	2025-09-21 19:39:13.492296	2025-09-21 19:39:13.492296
648	22759209-a7c7-47fa-81e8-4ec0d4ce01b9	2025-09-21 21:55:40.880576	2025-09-21 21:55:40.880576
649	1ba0595b-b11a-45aa-90ec-ab228677eb8c	2025-09-21 23:46:50.773547	2025-09-21 23:46:50.773547
650	1ff98db9-10b8-4bf1-9bc9-e262a2f13a1c	2025-09-21 23:46:53.055464	2025-09-21 23:46:53.055464
651	4dc82943-0f03-4bf6-a533-b931569439c2	2025-09-21 23:46:57.039059	2025-09-21 23:46:57.039059
652	53cadd96-04df-44ec-a61e-c3abbe4ea7ff	2025-09-22 01:59:43.048916	2025-09-22 01:59:43.048916
653	d6b428ec-b7ed-4d01-880f-4af6d1b5e7a7	2025-09-22 14:29:36.172788	2025-09-22 14:29:36.172788
654	8690d74e-80b9-4d5f-8bca-681b1739e040	2025-09-22 15:37:35.456509	2025-09-22 15:37:35.456509
655	e8ca7735-2869-416f-89df-5b6564babad2	2025-09-22 17:42:21.029315	2025-09-22 17:42:21.029315
656	841684bf-ac0a-4bb7-b8df-de0d281900ed	2025-09-23 07:23:45.668852	2025-09-23 07:23:45.668852
657	e7fbe20b-c4f9-47da-9c11-d3e7b6c8abaf	2025-09-23 11:03:30.564991	2025-09-23 11:03:30.564991
658	5a3fb95e-c5fa-4e3b-a8d5-b116837dd5e9	2025-09-24 02:55:33.893521	2025-09-24 02:55:33.893521
659	f8be89fa-537a-4ffe-b814-c3473f247543	2025-09-24 06:08:32.617642	2025-09-24 06:08:32.617642
660	8197f18b-e325-4009-bab3-ce2561216942	2025-09-24 07:03:18.959864	2025-09-24 07:03:18.959864
661	b99e19d1-8b2c-4425-8952-604ca2bfb891	2025-09-24 07:04:14.781551	2025-09-24 07:04:14.781551
662	e82449eb-6217-45bb-a1aa-3c248fa9ece0	2025-09-24 07:56:21.554488	2025-09-24 07:56:21.554488
663	dda73e05-dca4-4d84-9b68-1dac72e5041e	2025-09-24 08:30:07.556743	2025-09-24 08:30:07.556743
664	a16303c1-88ed-4332-8f82-6763e68ba9e5	2025-09-24 10:35:29.140391	2025-09-24 10:35:29.140391
665	f43d8562-e5b9-4285-b98f-9200359d8167	2025-09-24 21:58:10.850216	2025-09-24 21:58:10.850216
666	3958d616-ba16-44ca-b2b0-7a65f7a6c717	2025-09-25 04:10:35.29142	2025-09-25 04:10:35.29142
667	815563b9-96e9-40ca-a07e-f63b8cd0111d	2025-09-25 08:47:10.278603	2025-09-25 08:47:10.278603
668	4547370c-8d67-47ed-ad5c-3ec1bc32c38d	2025-09-25 11:20:12.124339	2025-09-25 11:20:12.124339
669	24eb110d-ea99-4068-8e55-42e1cec1f838	2025-09-25 12:05:30.177099	2025-09-25 12:05:30.177099
670	428acfba-6ccc-47eb-99f8-593c13a3a8d4	2025-09-25 12:26:23.106133	2025-09-25 12:26:23.106133
671	65a4701a-0073-4ce9-877a-ee03e5e81a3d	2025-09-25 16:18:58.641558	2025-09-25 16:18:58.641558
672	64166e4e-be45-45a3-8275-56905f17ce35	2025-09-26 17:33:05.985791	2025-09-26 17:33:05.985791
673	76c2ce75-a769-49e5-a50d-31ab3559c765	2025-09-28 14:24:38.463926	2025-09-28 14:24:38.463926
674	8370af62-5db0-4455-aae6-7ee5dfc6233f	2025-09-28 14:24:47.78138	2025-09-28 14:24:47.78138
675	db35b18a-ada8-4ee9-b515-efbd902ce9db	2025-09-28 14:25:30.333454	2025-09-28 14:25:30.333454
676	ea7adbef-c39d-4776-9ab4-5b3b745eaa08	2025-09-28 14:25:33.054603	2025-09-28 14:25:33.054603
677	6bed918f-ac8d-4cb8-9c11-6416a0f3ff1f	2025-09-28 14:25:35.563121	2025-09-28 14:25:35.563121
678	2c2cdb0f-8148-45a4-9e20-9bd09d6c4625	2025-09-28 15:59:37.728838	2025-09-28 15:59:37.728838
679	e1a60423-3ad6-4728-80f8-9d67f1ce4c9f	2025-09-28 15:59:43.310141	2025-09-28 15:59:43.310141
680	85e81b6e-8bcd-49b3-8769-8fe4a25d1594	2025-09-28 18:32:06.178481	2025-09-28 18:32:06.178481
681	98986db7-f5ec-4672-a13b-cb3318f27794	2025-09-29 02:29:48.844978	2025-09-29 02:29:48.844978
682	99029997-2599-4af6-8d0c-2bc7b8251d75	2025-09-29 02:30:13.335357	2025-09-29 02:30:13.335357
683	1cab90b1-aa03-482b-a8b7-99fb48cac1ff	2025-09-29 05:29:42.160048	2025-09-29 05:29:42.160048
684	75fbf6dc-14ce-4144-9ca9-580e7e1c2a1c	2025-09-29 14:56:39.39596	2025-09-29 14:56:39.39596
685	1bd17e93-eca5-4522-b9da-aacfc6a4555f	2025-09-29 16:51:33.092058	2025-09-29 16:51:33.092058
686	82ac1f99-7fb3-4339-8b2f-8671605c16c2	2025-09-29 16:52:17.409393	2025-09-29 16:52:17.409393
687	238bf043-7234-438b-b957-157b49d79708	2025-09-29 16:52:18.370542	2025-09-29 16:52:18.370542
688	7b44236f-a8a6-44db-83a8-9fe662f96e82	2025-09-29 16:52:19.655655	2025-09-29 16:52:19.655655
689	ada90b49-741c-42c0-aa5d-9d3e245c95e9	2025-09-30 02:06:31.451194	2025-09-30 02:06:31.451194
690	7aa08589-2a70-41b4-b940-f5b3fc15d45d	2025-09-30 02:06:34.738372	2025-09-30 02:06:34.738372
691	24d21f3f-da19-47cc-b0a0-6757520f0190	2025-09-30 06:31:22.032237	2025-09-30 06:31:22.032237
692	df8e3b61-4d0c-4ffe-a658-f3cccf0f0c97	2025-09-30 06:32:00.206868	2025-09-30 06:32:00.206868
693	80195b26-550f-4205-9cae-3a0f51b1c8e2	2025-09-30 06:32:00.381455	2025-09-30 06:32:00.381455
694	5580b466-ba89-4b19-b112-c543e0cc9e52	2025-09-30 06:32:00.416199	2025-09-30 06:32:00.416199
695	3d18bfff-84f5-46ed-b7cd-bbaaf9111d18	2025-09-30 15:29:47.735977	2025-09-30 15:29:47.735977
696	cdcf0449-f078-471b-9d1b-95774cbd3898	2025-09-30 23:14:56.184392	2025-09-30 23:14:56.184392
697	8ba2f8cf-c123-4130-870a-f7e5df496d3c	2025-09-30 23:33:54.003626	2025-09-30 23:33:54.003626
698	99fa59e9-0dc8-4dc1-8668-d4da113105b8	2025-09-30 23:33:55.032756	2025-09-30 23:33:55.032756
699	64381c62-c3b8-4892-9442-3d89ce7a3cf8	2025-09-30 23:33:55.667009	2025-09-30 23:33:55.667009
700	f94f3f55-36d1-4ec8-9c7d-e0c58b39f534	2025-10-01 00:30:45.677271	2025-10-01 00:30:45.677271
701	f9f68c90-29f9-4bff-988a-de8f5f8481f0	2025-10-01 08:00:26.823292	2025-10-01 08:00:26.823292
702	c97463ec-4c40-424e-8624-7ebd261ae12f	2025-10-01 08:00:34.541531	2025-10-01 08:00:34.541531
703	8a9fa236-88ce-4efd-be47-d5fe57321aaf	2025-10-02 06:17:31.647718	2025-10-02 06:17:31.647718
704	abee5858-3e0e-4d75-b8f0-88c962561db8	2025-10-02 15:53:11.117359	2025-10-02 15:53:11.117359
705	e1c75466-9f38-429e-89bf-87bdb5788685	2025-10-03 02:33:56.703487	2025-10-03 02:33:56.703487
706	b715a5ca-a010-431c-9e54-b393aed14fb1	2025-10-03 09:11:06.306829	2025-10-03 09:11:06.306829
707	3e856536-ff57-4ee9-ad6b-b3d89043403d	2025-10-03 13:14:05.661022	2025-10-03 13:14:05.661022
708	0007c602-fbac-4db6-80b1-de307427394d	2025-10-04 05:27:00.426331	2025-10-04 05:27:00.426331
709	3ee1d6ad-9f4c-436a-8f80-816a2a19a099	2025-10-04 12:04:36.337113	2025-10-04 12:04:36.337113
710	7a81ec34-a1ed-46c3-9d37-4233aea74f87	2025-10-05 05:10:46.955438	2025-10-05 05:10:46.955438
711	c2ddb7d0-247b-430b-b72b-3a04512412ea	2025-10-05 08:31:47.394591	2025-10-05 08:31:47.394591
712	acd427ea-ad5b-4aa9-bccd-ebac8ba7736f	2025-10-05 10:30:48.825626	2025-10-05 10:30:48.825626
713	112dddaa-8639-4547-bd1c-fd8c0e04afb7	2025-10-05 22:52:52.182083	2025-10-05 22:52:52.182083
714	17c155ae-3608-4acc-ae88-c1cc855ec456	2025-10-05 23:22:53.495128	2025-10-05 23:22:53.495128
715	e627442a-43bb-4784-94eb-73b972cd728c	2025-10-06 15:54:54.9138	2025-10-06 15:54:54.9138
716	8f3f20b4-e957-46a0-a1a3-1d57e4a24d4f	2025-10-07 04:31:56.539871	2025-10-07 04:31:56.539871
717	3707a542-ef9a-423e-9a9a-d1551167098b	2025-10-07 04:32:00.116335	2025-10-07 04:32:00.116335
729	115a6b5c-f52c-492d-99bf-134de4c9ec2f	2025-10-09 15:30:45.816183	2025-10-09 15:30:45.816183
730	d3603c42-8546-4bd5-be8d-cf7dc825e931	2025-10-10 03:03:54.352213	2025-10-10 03:03:54.352213
731	82934efe-1f6f-41f1-8a0b-71c1bcb225f0	2025-10-10 03:26:00.462227	2025-10-10 03:26:00.462227
732	47cf8d24-e798-43ea-a93f-2f9c993c617f	2025-10-10 05:19:56.282146	2025-10-10 05:19:56.282146
733	5081f6a2-2032-4025-bba0-fd12b8b663e5	2025-10-10 06:14:47.049556	2025-10-10 06:14:47.049556
734	a457219b-ec61-44da-beec-fd644b4b5b09	2025-10-10 06:57:56.815424	2025-10-10 06:57:56.815424
735	24763a95-6804-4715-adca-ba129f82cffa	2025-10-10 07:39:51.773642	2025-10-10 07:39:51.773642
736	88013808-7072-4822-be29-8e562e2ae108	2025-10-10 07:55:47.650681	2025-10-10 07:55:47.650681
737	0f345fc4-e4ab-49dd-b696-d6f68648feb8	2025-10-10 12:02:34.103187	2025-10-10 12:02:34.103187
738	429f64c3-23b1-4f7f-8057-a58ff4ef485c	2025-10-10 13:40:25.160581	2025-10-10 13:40:25.160581
739	57db169c-4937-43de-90a8-8281d149c685	2025-10-11 03:22:22.49819	2025-10-11 03:22:22.49819
740	8dcb8bbe-4535-4f6e-9422-d09307d6772a	2025-10-11 03:22:24.926247	2025-10-11 03:22:24.926247
748	6a8aafcd-7891-41f1-baa7-cd12530dbacd	2025-10-13 01:03:54.989878	2025-10-13 01:03:54.989878
749	d1a5ed87-a50f-42bd-843d-31e91f3f584a	2025-10-13 01:49:31.61878	2025-10-13 01:49:31.61878
750	83131fb4-09d3-4a05-9cd3-90d034c12a45	2025-10-13 04:13:04.544905	2025-10-13 04:13:04.544905
751	236b2a63-888c-4a92-b710-4b86f85056b9	2025-10-13 09:07:12.969224	2025-10-13 09:07:12.969224
752	c0ff6d02-aee2-49d1-a4a5-0df27307d5ed	2025-10-13 12:53:12.013204	2025-10-13 12:53:12.013204
753	539ce60d-ef0e-4f09-bab7-2c22e9fc1870	2025-10-13 18:05:11.273891	2025-10-13 18:05:11.273891
754	8d1ea68f-03e1-4cb3-ac6b-04ce4c8bfbaf	2025-10-14 01:06:35.309903	2025-10-14 01:06:35.309903
755	c5086e26-7f9f-497b-9a20-6146cfd11f44	2025-10-14 01:10:11.102086	2025-10-14 01:10:11.102086
756	c17a925f-de62-4355-bc5a-98ac0077b93f	2025-10-14 01:12:31.923827	2025-10-14 01:12:31.923827
757	a5d32bbf-530e-478a-93e5-4c0b05aa1168	2025-10-14 04:22:13.745075	2025-10-14 04:22:13.745075
758	ece374eb-014a-4cde-ad55-0ab5914ed54d	2025-10-14 04:57:54.695796	2025-10-14 04:57:54.695796
759	c9072dd2-3d70-48ab-80f5-ca219318f73e	2025-10-14 10:43:28.852233	2025-10-14 10:43:28.852233
760	42eb98b2-b834-4cb2-8017-d6094061fa72	2025-10-14 11:59:33.54999	2025-10-14 11:59:33.54999
761	20efabf9-5ad4-4f4e-81aa-89e25b5db950	2025-10-14 12:06:30.526613	2025-10-14 12:06:30.526613
762	8d031393-7b37-4601-9f90-545d5a800dcb	2025-10-14 12:24:04.097025	2025-10-14 12:24:04.097025
763	149d9bbf-96a3-459f-82e4-d51b990442b8	2025-10-14 15:00:46.690912	2025-10-14 15:00:46.690912
764	899d11f1-75cb-4331-b615-e126af895030	2025-10-15 02:07:35.2387	2025-10-15 02:07:35.2387
765	304e441a-7d7f-493a-86a3-87be55e9f598	2025-10-15 03:31:24.698595	2025-10-15 03:31:24.698595
766	b375d33b-b0ed-4eb9-89d4-479bc94635e6	2025-10-16 04:05:38.951533	2025-10-16 04:05:38.951533
767	b8f08ec9-1fc1-40d2-9e80-bf0a94bf848e	2025-10-16 06:17:42.316605	2025-10-16 06:17:42.316605
768	91424f1f-e276-48bd-b20d-a750cfd423fc	2025-10-16 14:33:02.142148	2025-10-16 14:33:02.142148
769	b0392d55-e8e7-4b34-ab7f-6fde89ded30c	2025-10-16 16:53:12.52451	2025-10-16 16:53:12.52451
720	113ebc73-c6d8-4ff8-b2a2-45b183a13cba	2025-10-08 10:00:09.764686	2025-10-08 10:00:09.764686
721	535cc85b-0fd1-455b-a3d3-5342e4ad1882	2025-10-08 10:05:23.595146	2025-10-08 10:05:23.595146
722	a65ce043-8f91-413b-83ce-9d388ffe65e1	2025-10-08 10:07:45.661209	2025-10-08 10:07:45.661209
723	970dd900-ad66-4b25-b964-f9a2ef8e6fd3	2025-10-08 22:15:49.521641	2025-10-08 22:15:49.521641
724	fc7f0dbe-1c8f-488d-ab48-a14645ccd672	2025-10-08 22:15:49.761837	2025-10-08 22:15:49.761837
770	50fd2f6c-8ed8-412b-af5f-162d32c7a59d	2025-10-16 17:09:22.669255	2025-10-16 17:09:22.669255
771	6d06c3a6-42bc-411a-a801-e264ed0a3073	2025-10-16 17:09:25.802845	2025-10-16 17:09:25.802845
718	56b19427-5a94-477a-960d-986b03c35339	2025-10-08 05:40:37.163173	2025-10-11 04:50:49.493
772	8c5651b9-8784-494a-8222-ab98dc5a6cc0	2025-10-16 21:05:57.006071	2025-10-16 21:05:57.006071
773	83e6cd27-71d8-4652-8bf8-55f339297ea2	2025-10-17 02:33:18.142025	2025-10-17 02:33:18.142025
774	a0fa2019-03e4-4a15-8974-f753259563a1	2025-10-17 04:12:29.002618	2025-10-17 04:12:29.002618
775	a1c1ba95-eedd-4c0a-98d9-7138bcab3ba6	2025-10-17 04:12:30.40667	2025-10-17 04:12:30.40667
719	03bcdcdd-0cec-4e08-aafe-533cdae6a6cc	2025-10-08 09:58:58.593979	2025-10-11 04:54:44.996
741	d4916372-8f16-4334-84b0-30d53fa9805b	2025-10-12 02:59:30.063487	2025-10-12 02:59:30.063487
742	d685f180-17a2-4a2d-a170-5a7bb619af76	2025-10-12 03:20:13.063016	2025-10-12 03:20:13.063016
743	73328afc-8407-42ea-a414-9b6879628079	2025-10-12 05:22:27.322207	2025-10-12 05:22:27.322207
725	b46e0be7-171b-473b-bd93-e5f249990e9f	2025-10-09 07:04:20.772469	2025-10-09 07:04:20.772469
744	31d57d2b-6967-4956-bbd7-e75f22b2cfd2	2025-10-12 05:23:21.079258	2025-10-12 05:23:21.079258
745	19a7604d-4e53-4362-b0e4-529f8f20ae4a	2025-10-12 09:02:35.234327	2025-10-12 09:02:35.234327
776	f811dc9d-eb5c-4a43-8a1e-fd34b8e14278	2025-10-17 11:55:39.752716	2025-10-17 11:55:39.752716
726	be8ce685-98a8-4299-a91c-e60bd234c0da	2025-10-09 07:13:46.721415	2025-10-09 07:13:46.721415
727	f1224c4c-f71e-433e-80a7-a7d859047e4a	2025-10-09 08:45:18.184159	2025-10-09 08:45:18.184159
728	3f2fa233-444b-4e87-a5c4-0277499c4be4	2025-10-09 10:00:24.422931	2025-10-09 10:00:24.422931
746	b337a409-0891-44aa-9417-7da404ef9807	2025-10-12 11:33:24.925668	2025-10-12 11:33:24.925668
747	aa212b74-6f2a-4113-b46b-36f79e4ae21c	2025-10-12 11:33:28.263681	2025-10-12 11:33:28.263681
777	383993c9-f2c3-4287-a28e-3bd09b44298a	2025-10-17 14:41:19.000009	2025-10-17 14:41:19.000009
779	782897fa-55d9-40db-8200-6605b841de64	2025-10-17 21:20:32.566787	2025-10-17 21:20:32.566787
780	015ef8d3-c32f-4d48-a3b4-719d6d2af6b6	2025-10-17 21:28:02.481086	2025-10-17 21:28:02.481086
781	fc4e8949-8694-4ca2-a22a-04d580bab6a0	2025-10-17 22:59:51.878371	2025-10-17 22:59:51.878371
782	fb85b830-77a7-4388-987c-4e87e20dfea4	2025-10-18 00:40:22.767581	2025-10-18 00:40:22.767581
783	f0d84b00-de45-4b0c-b09d-a0b811d324b6	2025-10-18 14:52:07.04936	2025-10-18 14:52:07.04936
784	bc4a5fe0-bfde-4e5d-92a9-605599ea97f8	2025-10-20 01:13:32.610973	2025-10-20 01:13:32.610973
785	8a957988-515f-4635-aed5-40b71645f685	2025-10-20 02:36:32.377571	2025-10-20 02:36:32.377571
30	27da7a88-74fa-4636-99b7-67d4ede93018	2025-08-14 01:39:55.366483	2025-10-27 09:58:29.998
786	e3811c38-bdae-4f2f-a604-c3bba62ec1ce	2025-10-20 09:33:27.14709	2025-10-20 09:33:27.14709
787	78ff37ee-dbca-4e9e-a50a-dbb94d78ca35	2025-10-20 13:34:17.523756	2025-10-20 13:34:17.523756
788	d9a7accd-2b79-400f-b06d-ea70ba9ccc65	2025-10-20 14:34:30.859374	2025-10-20 14:34:30.859374
789	0c6fa546-9223-44c6-ba47-1e6d00595fd8	2025-10-20 18:19:03.064599	2025-10-20 18:19:03.064599
790	de15d441-f925-43d3-92e1-1c9f68d7dd0c	2025-10-20 18:43:52.302295	2025-10-20 18:43:52.302295
791	91b170a1-c69d-45da-b0e8-b544343c27be	2025-10-20 23:02:11.18044	2025-10-20 23:02:11.18044
792	ea2cb7c6-5485-4627-a25d-4a6f96aca09a	2025-10-21 01:28:39.664781	2025-10-21 01:28:39.664781
793	38e19d76-47f0-4a19-b2aa-1a5f429a7511	2025-10-21 01:40:12.179811	2025-10-21 01:40:12.179811
794	19f9066d-967b-46d0-8fcf-14694aadbba8	2025-10-21 04:05:12.692091	2025-10-21 04:05:12.692091
778	88875e05-7dcc-4a92-b48c-058b4c6255c9	2025-10-17 14:48:31.030211	2025-10-21 05:44:24.158
795	dcd789cc-cb68-4484-928f-994f302f869a	2025-10-21 05:59:20.895166	2025-10-21 05:59:20.895166
796	070f2b61-326e-427a-af1f-39da004b728f	2025-10-21 06:03:09.986002	2025-10-21 06:03:09.986002
797	f3754fc5-bb75-47b9-aecb-882a02acd8d2	2025-10-21 09:07:42.500979	2025-10-21 09:07:42.500979
798	e238f09c-41e0-48f2-ae76-f5100e94b30e	2025-10-21 09:38:56.799988	2025-10-21 09:38:56.799988
799	cab14c94-2557-4d50-9503-9bcf64c54ea5	2025-10-21 16:10:58.947683	2025-10-21 16:10:58.947683
800	feeeeb41-4dd3-4f78-955d-3a868b7f1081	2025-10-21 22:42:16.348434	2025-10-21 22:42:16.348434
801	0b9db6ed-c006-4691-a67c-59354a196c8d	2025-10-22 11:55:58.426187	2025-10-22 11:55:58.426187
802	4c56c3bb-a864-49f2-9430-7afd5124e18e	2025-10-22 13:11:17.569822	2025-10-22 13:11:17.569822
803	7ca5c67d-8b15-4ef3-9343-049434d2bba3	2025-10-22 14:45:33.25581	2025-10-22 14:45:33.25581
804	9669f956-31eb-4196-8b3f-8a3a9d618c44	2025-10-23 00:08:37.738	2025-10-23 00:08:37.738
805	acfaa4f7-ed8c-41b3-a042-ba133b5c3d71	2025-10-23 10:32:43.358211	2025-10-23 10:32:43.358211
806	d496a26a-c4f6-4cde-b045-f4c2aa112b4c	2025-10-23 10:32:50.133628	2025-10-23 10:32:50.133628
807	fc951208-d27f-40a0-ba0e-15fd97e4a765	2025-10-23 14:00:46.361855	2025-10-23 14:00:46.361855
808	b7dcd727-1cfe-45b1-9d66-e1c1fa1d6b25	2025-10-23 15:51:27.339406	2025-10-23 15:51:27.339406
809	b3ce1dd2-0dd7-4db2-88f3-577e8b5a43b0	2025-10-24 03:27:18.316614	2025-10-24 03:27:18.316614
810	c4cc716f-0101-4704-98f6-fe8c3715936a	2025-10-24 06:14:59.665845	2025-10-24 06:14:59.665845
861	955e74a5-07c3-4f1b-81c3-7c4da97fc6a5	2025-11-03 11:48:39.241655	2025-11-03 11:48:39.241655
862	7b135ea2-29fe-46e3-9755-dfd9042e5f32	2025-11-03 11:51:38.550758	2025-11-03 11:51:38.550758
811	2833550c-ef7e-45a2-b416-57717e28a90f	2025-10-24 08:04:01.838625	2025-10-24 08:06:22.378
812	b653585a-9cc5-4907-9836-bbf8094ffe99	2025-10-24 13:57:13.41908	2025-10-24 13:57:13.41908
813	6851a1ac-ebac-4e32-b2e8-9c85f6feeee3	2025-10-24 17:16:47.970691	2025-10-24 17:16:47.970691
814	7b6b869d-3caf-48c5-82b5-153ddbab0ad3	2025-10-25 14:43:27.161273	2025-10-25 14:43:27.161273
815	dcd41322-c68e-43aa-8228-81b223348de1	2025-10-25 14:49:26.097141	2025-10-25 14:49:26.097141
816	1f9e4f15-3ccd-466d-8b35-d6152873624d	2025-10-25 14:49:26.512955	2025-10-25 14:49:26.512955
817	d24ef58b-41a3-4cbc-afaf-1b0329145cdb	2025-10-25 16:09:19.305835	2025-10-25 16:09:19.305835
818	dd848e28-5668-4865-b52a-9537348fcae4	2025-10-25 16:48:52.834352	2025-10-25 16:48:52.834352
819	2c7b3335-30f5-432e-916a-e9a558419499	2025-10-25 19:25:40.837823	2025-10-25 19:25:40.837823
820	2400ea4b-d752-4dce-86d3-b2272d55ba75	2025-10-26 01:09:38.702639	2025-10-26 01:09:38.702639
821	224595e0-3902-47e4-9afc-3983e66baeb1	2025-10-26 02:31:07.88133	2025-10-26 02:31:07.88133
822	47fc0573-c20a-4e04-98dd-424584f381f8	2025-10-26 07:50:26.171509	2025-10-26 07:50:26.171509
823	ae2b2248-4173-4f8d-bcf8-2634591b46c1	2025-10-26 10:37:28.764994	2025-10-26 10:37:28.764994
824	0d5ce7b4-f72b-40cd-b368-a4aa4b9c3036	2025-10-26 12:25:08.135383	2025-10-26 12:25:08.135383
825	9f6d1327-d01f-43f8-8e6f-a97cbdbd175e	2025-10-26 16:10:07.685041	2025-10-26 16:10:07.685041
826	0204c3bf-f5e7-45d3-a256-24cac05b1cfb	2025-10-27 10:01:28.291472	2025-10-27 10:01:28.291472
827	00ffc306-5ebe-4292-a6bd-058f02487a8f	2025-10-27 11:40:28.825115	2025-10-27 11:40:28.825115
828	e64b7c41-5237-4176-a36c-dde1bf9e05bc	2025-10-27 12:46:56.817979	2025-10-27 12:46:56.817979
829	c46a04d0-f6c8-4357-bee4-2e1ea98f30cc	2025-10-27 17:14:17.66448	2025-10-27 17:14:17.66448
830	b5250f3a-ca19-42e2-af17-f1ca2fb30c9e	2025-10-27 20:59:25.821384	2025-10-27 20:59:25.821384
831	6e0a309f-3759-4157-8aed-0a05f859a1b1	2025-10-28 00:13:11.327381	2025-10-28 00:13:11.327381
832	2703c73e-99c7-431c-932a-c56a58ae2286	2025-10-28 00:56:16.243926	2025-10-28 00:56:16.243926
833	2fa8ac45-a698-4bb8-a5a0-d7c6d480d842	2025-10-28 02:34:09.700363	2025-10-28 02:34:09.700363
834	8cdf286e-d606-4593-9c50-794000690bb9	2025-10-28 09:17:32.824566	2025-10-28 09:17:32.824566
835	ea25fffe-1b05-42bd-bfe3-b17fe60372c6	2025-10-28 14:45:41.124333	2025-10-28 14:45:41.124333
836	812fe6b4-5f8d-4085-a916-01514c2f3b1c	2025-10-28 15:02:46.878715	2025-10-28 15:02:46.878715
837	14cbfe72-5052-4eb4-ae74-4a273ce2a77a	2025-10-28 15:16:45.727997	2025-10-28 15:16:45.727997
838	063b0d15-2fe1-4415-beef-552681dcd344	2025-10-28 15:54:48.479529	2025-10-28 15:54:48.479529
839	3584248d-a1a0-48bc-94dd-d93d103e5c19	2025-10-28 21:23:38.087186	2025-10-28 21:23:38.087186
840	f67adb4a-bf1e-407a-82e7-3ab1a10587bd	2025-10-29 07:06:19.888341	2025-10-29 07:06:19.888341
841	bae28445-4615-47bd-a9bd-1b67f44b3aae	2025-10-29 12:43:26.723349	2025-10-29 12:43:26.723349
863	7128a1ef-6321-49e1-a61c-1cb9fcd8af69	2025-11-03 12:37:20.021812	2025-11-03 12:37:20.021812
847	9e75e758-3d72-4a84-ba46-c5321d4deefa	2025-10-30 11:05:32.926178	2025-10-31 03:49:30.686
842	e51e6a46-c83f-41fd-9e25-7ce1f2890573	2025-10-29 13:00:29.566302	2025-10-29 13:10:08.136
843	4f18ef4e-0654-46a4-8326-c3076a95c88d	2025-10-29 18:07:41.267636	2025-10-29 18:07:41.267636
844	81f23517-77c1-4f91-9e10-ca59650207ae	2025-10-30 01:27:50.486613	2025-10-30 01:27:50.486613
845	261d2fec-ba59-435c-8280-6e4ee2309bf9	2025-10-30 01:34:58.665891	2025-10-30 01:34:58.665891
846	26c56d5b-75c2-45c6-9a5c-439382b32bd5	2025-10-30 02:18:28.079721	2025-10-30 02:18:28.079721
855	fb12ccf4-a8e9-4419-a327-468e7773c527	2025-10-31 03:49:53.613717	2025-10-31 03:49:53.613717
856	f24e1488-7810-4748-838f-5d3e3b36e8c8	2025-11-01 05:40:18.246362	2025-11-01 05:40:18.246362
857	4406bc29-956d-43eb-8cb0-6a03d29dd60c	2025-11-01 08:57:17.230989	2025-11-01 08:57:17.230989
848	58ca1505-0dd3-44a1-b1cb-8d3fcaf029e5	2025-10-30 14:40:19.667189	2025-10-30 14:40:19.667189
849	70f1b7ed-d09e-40b2-920d-4eeb844b16e7	2025-10-30 16:08:42.364571	2025-10-30 16:08:42.364571
850	cf546023-abcc-44ec-96f1-73933beee106	2025-10-30 16:17:57.524623	2025-10-30 16:17:57.524623
851	f87c1a17-e483-4a3e-a090-645d272c90be	2025-10-30 17:49:21.680521	2025-10-30 17:49:21.680521
852	be14b9b0-469e-4bef-aa67-c19cbb680951	2025-10-30 23:24:18.241273	2025-10-30 23:24:18.241273
853	de80e927-5cd2-4db3-9872-53bdac956b9f	2025-10-30 23:59:44.753477	2025-10-30 23:59:44.753477
854	0f9bff1c-6fba-47c4-a4ba-aa684adc1bea	2025-10-31 00:41:47.566233	2025-10-31 00:41:47.566233
864	64ce012a-4b14-452c-aca9-0bfe7541ba88	2025-11-04 03:36:28.762076	2025-11-04 03:36:28.762076
858	6c1d5f02-e4fd-427b-8be5-a8667ccc9973	2025-11-01 12:17:39.000873	2025-11-01 12:17:39.000873
859	8b82ddd3-dde8-4a71-8616-1a23f29ba289	2025-11-01 13:33:47.062287	2025-11-01 13:33:47.062287
860	3498bdce-a0e8-40af-9459-df3f8fccc4f8	2025-11-02 05:45:19.013927	2025-11-02 05:45:19.013927
865	637e2d23-1621-4044-b83d-59b683d2c8a0	2025-11-04 17:14:18.173815	2025-11-04 17:14:18.173815
866	7571c9f8-52dc-4b5a-9d58-c265c2a97361	2025-11-05 01:29:26.454944	2025-11-05 01:29:26.454944
867	5191ccdc-ec78-4f77-be67-64cd63e351d7	2025-11-05 14:15:15.347217	2025-11-05 14:15:15.347217
868	8d46f131-213f-4644-aeeb-1d5c6a643da5	2025-11-05 22:58:41.825609	2025-11-05 22:58:41.825609
869	6077f71b-12e1-4764-ad17-fef87001ba71	2025-11-06 00:14:23.175158	2025-11-06 00:14:23.175158
870	6e1e2d30-02a8-414f-a52a-4d983c8649cd	2025-11-06 10:38:57.556339	2025-11-06 10:38:57.556339
871	ed366e90-ea80-4c49-bba5-2dfd6afaa565	2025-11-06 17:19:27.759828	2025-11-06 17:19:27.759828
872	243c71bd-4605-453f-95be-5e1ab783a501	2025-11-06 19:29:24.17233	2025-11-06 19:29:24.17233
873	a4da7d82-e751-4ed2-8d4a-c146cbe2263b	2025-11-07 04:01:05.381291	2025-11-07 04:01:05.381291
874	f780d810-1c27-48a6-be5f-6b96554402c7	2025-11-07 11:38:35.745872	2025-11-07 11:38:35.745872
875	ea837f1e-3364-4d0d-8d1b-2d8f7c048db3	2025-11-07 18:13:19.023476	2025-11-07 18:13:19.023476
876	613954c6-1e11-4797-84c1-831f9e31f21c	2025-11-08 02:00:33.674023	2025-11-08 02:00:33.674023
877	c087ed4b-810b-4ec2-bad5-ff12900ded3e	2025-11-08 02:09:09.172042	2025-11-08 02:09:09.172042
878	53a6cad4-780e-4c13-8ad4-e6556db166b2	2025-11-08 02:10:16.125814	2025-11-08 02:10:16.125814
879	b7244b3d-f7b2-4741-a04a-b418f6e8efd6	2025-11-08 02:12:19.30103	2025-11-08 02:12:19.30103
880	d62f21d6-84a2-4322-a247-4fdd6ac3f3e3	2025-11-08 04:33:25.22172	2025-11-08 04:33:25.22172
881	8a20e709-e435-4e4f-807a-ec62bd76cc9f	2025-11-10 02:17:52.654072	2025-11-10 02:17:52.654072
882	ec4b0e98-8a4f-4cc9-a6b1-4c9793d302be	2025-11-10 12:46:32.02829	2025-11-10 12:46:32.02829
883	b59e9d0d-fb8c-4367-8178-4ae3505d0966	2025-11-10 12:56:27.950292	2025-11-10 12:56:27.950292
884	ac1d8b8d-5544-4e07-a4f4-e035862cb686	2025-11-10 13:32:23.6674	2025-11-10 13:32:23.6674
885	c4adc03f-44f1-4ddc-bdc4-32fe91725467	2025-11-10 14:27:15.684878	2025-11-10 14:27:15.684878
886	3d1ae34c-572b-48c5-8413-00a261923210	2025-11-10 14:27:21.398621	2025-11-10 14:27:21.398621
887	0605a8ba-c144-455e-b523-4d104c472631	2025-11-10 15:33:59.589727	2025-11-10 15:33:59.589727
888	993813a1-b535-49ea-94f4-f3d4ed66892b	2025-11-10 15:52:08.873022	2025-11-10 15:52:08.873022
889	77e97215-e94c-4e3f-a1f3-66b6109c6483	2025-11-10 16:36:08.975372	2025-11-10 16:36:08.975372
890	cc3a85fe-9e7a-4f7e-9c68-c10aab3e5615	2025-11-10 19:34:49.903051	2025-11-10 19:34:49.903051
891	a5192ad4-6751-4099-98e1-0044f6a81af9	2025-11-10 20:14:37.05343	2025-11-10 20:14:37.05343
892	f052df8f-aedd-4c0a-9b94-a284747e2776	2025-11-10 22:32:06.567894	2025-11-10 22:32:06.567894
893	719c195e-e2ad-4c77-95ee-621f79285354	2025-11-11 00:16:58.860256	2025-11-11 00:16:58.860256
894	7beb8da2-e563-408f-845e-c0c3a13285fe	2025-11-11 02:19:28.362696	2025-11-11 02:19:28.362696
895	84d5f045-13ce-48c5-94e5-55b9bf8fd046	2025-11-11 12:53:08.110902	2025-11-11 12:53:08.110902
896	93a84d41-57cf-4d58-9dec-1200aea43c40	2025-11-11 13:12:07.257353	2025-11-11 13:12:07.257353
897	a9bfa865-baca-4407-b374-8b43bf89b0ee	2025-11-11 20:17:33.631873	2025-11-11 20:17:33.631873
898	146dcd13-0bf8-4481-a2cb-0617b2af2549	2025-11-11 20:21:04.086781	2025-11-11 20:21:04.086781
899	c70845d6-cddc-40e0-b791-c8c59892976a	2025-11-12 07:48:14.967968	2025-11-12 07:48:14.967968
900	de3f27a2-ebb6-4da9-a5b2-6512bc130955	2025-11-12 15:30:35.616471	2025-11-12 15:30:35.616471
901	812c242c-33c9-4680-b27b-0f6bd76443a6	2025-11-12 20:42:54.719461	2025-11-12 20:42:54.719461
902	40324bc0-4165-4def-a622-936506fa5bac	2025-11-12 23:01:16.294267	2025-11-12 23:01:16.294267
903	6932ef56-0edc-439f-99ec-fe4334704bfb	2025-11-13 00:21:36.15724	2025-11-13 00:21:36.15724
904	f69b4ddc-79b3-4656-aa33-d1750e608767	2025-11-13 06:33:37.530834	2025-11-13 06:33:37.530834
905	b3a66b87-6bbc-4660-8f89-c65c97bfdadd	2025-11-13 06:45:27.518168	2025-11-13 06:45:27.518168
906	5b0793c9-ad57-4d70-9bee-cf620a0f1c82	2025-11-13 06:46:04.439668	2025-11-13 06:46:04.439668
907	3bb2ad0c-11d6-4cee-be82-8da7c72c0785	2025-11-13 10:42:21.74283	2025-11-13 10:42:21.74283
908	182de2b9-0d63-4864-a996-4b8cfea42b40	2025-11-13 10:45:08.632393	2025-11-13 10:45:08.632393
909	d3c9de0f-e18d-436c-a1f0-68803fbe5794	2025-11-13 11:34:26.261074	2025-11-13 11:34:26.261074
1243	a65bc489-fe99-4fce-a2b1-8f7fb0749a60	2025-12-18 08:23:42.899998	2025-12-18 08:23:42.899998
1244	b8c18315-e1f2-4a90-b093-d1f8c790762b	2025-12-18 08:23:52.599959	2025-12-18 08:23:52.599959
1250	78cd9d5b-7309-4ac0-91f4-57b1dd139690	2025-12-18 08:51:14.969028	2025-12-18 08:51:14.969028
1256	12bad6ac-41d0-45a3-b47c-c98b38e52dc7	2025-12-18 09:46:29.866594	2025-12-18 09:46:29.866594
1262	47cf212f-6008-4963-812b-c46fb1ed2f0c	2025-12-18 10:15:36.523511	2025-12-18 10:15:36.523511
1268	7d794f61-7c97-433b-8a71-65e0f0b1d467	2025-12-18 10:47:31.861301	2025-12-18 10:47:31.861301
1274	f0f9ce09-9867-4f6b-b4c9-ff9b33bb5bd8	2025-12-18 11:18:43.233641	2025-12-18 11:18:43.233641
1281	e69a5ab9-ffda-4f3c-8902-af8091e3607e	2025-12-18 12:25:36.463697	2025-12-18 12:25:36.463697
1287	58957f53-e2ad-4d7e-8527-fc37474c3475	2025-12-18 14:00:36.442307	2025-12-18 14:00:36.442307
1293	29bb69d7-97e5-4931-9743-154574ba6472	2025-12-18 15:21:59.57798	2025-12-18 15:21:59.57798
1299	b44f76e1-7a3b-4f8e-824a-1651a8a25d7f	2025-12-18 16:20:06.705925	2025-12-18 16:20:06.705925
1306	51dac618-4842-438f-8bc3-f3bd434bd2ba	2025-12-18 17:03:47.435302	2025-12-18 17:03:47.435302
1312	5c50dda2-433e-40b1-8320-8bba01eb8f77	2025-12-18 17:57:02.740999	2025-12-18 17:57:02.740999
1318	83ebafca-1a87-4872-8720-3d58573f246f	2025-12-19 00:21:34.39663	2025-12-19 00:21:34.39663
1324	2148c570-0dd5-465e-847a-f217f13a477c	2025-12-19 02:16:54.811126	2025-12-19 02:16:54.811126
1325	77a9947e-c119-4209-b420-f265aaa2c7db	2025-12-19 02:16:57.551992	2025-12-19 02:16:57.551992
1331	d6ac4565-a24d-42c1-9d33-294e918a3d4b	2025-12-19 03:49:32.273925	2025-12-19 03:49:32.273925
1337	7dad7af9-c243-4938-a92a-9fb6505375c9	2025-12-19 04:28:02.923429	2025-12-19 04:28:02.923429
1343	19a4c9bd-b7c5-463d-9658-e9ce6ff5a117	2025-12-19 04:57:28.589929	2025-12-19 04:57:28.589929
1349	c82cbbda-5282-4bf7-9a95-97299616f966	2025-12-19 05:51:52.485213	2025-12-19 05:51:52.485213
1355	2ba2ce2c-d52c-46fe-9a84-bef3abfbdaff	2025-12-19 06:09:27.824263	2025-12-19 06:09:27.824263
1360	24853be8-51fd-40f0-af9b-1dfb1bb713ec	2025-12-19 06:35:40.692608	2025-12-19 06:35:40.692608
1365	49bba273-25c2-40da-96cf-a6f9e0a21de5	2025-12-19 06:49:05.908716	2025-12-19 06:49:05.908716
1369	482300fc-dbb4-4906-a891-6413153061e8	2025-12-19 06:57:04.021652	2025-12-19 06:57:04.021652
1372	4bb7eba1-a287-4ac8-8161-fd3ab3732e0a	2025-12-19 07:12:00.301856	2025-12-19 07:12:00.301856
1375	a0736958-b60a-422b-a968-01f16fc40960	2025-12-19 07:29:13.249302	2025-12-19 07:29:13.249302
1376	3b4a2bad-c94a-4e5d-b867-eb0f4637b93b	2025-12-19 07:35:06.703227	2025-12-19 07:35:06.703227
1377	1f6c255b-e331-4385-805a-755d03d28556	2025-12-19 07:42:49.583823	2025-12-19 07:42:49.583823
1378	de54296a-e0f6-43f4-85f1-42b1851654f7	2025-12-19 07:43:27.530977	2025-12-19 07:43:27.530977
1379	da9a9c53-d2c4-4947-84cc-88f7fec96f30	2025-12-19 07:44:17.521161	2025-12-19 07:44:17.521161
1380	8de505f7-5774-4d26-ae61-f1329080d6cc	2025-12-19 07:45:39.635424	2025-12-19 07:45:39.635424
1381	b58a910c-fe15-483e-92fa-e51adf632680	2025-12-19 07:53:32.108263	2025-12-19 07:53:32.108263
1382	088fc80f-bc03-4eb3-ae2c-ad54e71745cc	2025-12-19 07:55:57.213513	2025-12-19 07:55:57.213513
1383	184d6885-5adc-4a9d-acce-551de0ed6f5a	2025-12-19 08:04:11.608847	2025-12-19 08:04:11.608847
1384	43278558-f9d9-47ea-b1c1-8287f5760ab1	2025-12-19 08:08:57.163868	2025-12-19 08:08:57.163868
1385	f5886b5a-0c69-49f2-8117-b807f93cd0dc	2025-12-19 08:11:54.837482	2025-12-19 08:11:54.837482
1386	d272f938-d520-44b5-b6a6-80178c7b6f54	2025-12-19 08:12:25.600482	2025-12-19 08:12:25.600482
1387	c2c7b0c6-5abd-4443-a9f7-c0b60c028452	2025-12-19 08:16:50.102003	2025-12-19 08:16:50.102003
1388	9db745b1-4cf5-406d-8978-f458c071305b	2025-12-19 08:18:37.012282	2025-12-19 08:18:37.012282
1389	fc2de373-c7e6-4d53-ac39-7fd2a2e62269	2025-12-19 08:21:42.852711	2025-12-19 08:21:42.852711
1390	e17c4977-21a6-4423-9daf-b97d24c89f80	2025-12-19 08:22:58.082335	2025-12-19 08:22:58.082335
1391	ef1e9d16-d8bc-4e40-8320-5e1778beb843	2025-12-19 08:26:48.88168	2025-12-19 08:26:48.88168
1392	ffe77150-14c8-4d10-aa87-45e97e1022ab	2025-12-19 08:28:32.04085	2025-12-19 08:28:32.04085
1393	c9fc5c9e-ff81-4823-ba49-5d4bcf08ea94	2025-12-19 08:32:03.962969	2025-12-19 08:32:03.962969
1394	00f2ca61-8c31-4b16-a4d1-f29ee3d8ef59	2025-12-19 08:34:33.218432	2025-12-19 08:34:33.218432
1395	2b3590bd-8533-43b4-9bb5-018544cf14b7	2025-12-19 08:38:30.452074	2025-12-19 08:38:30.452074
1396	b72b9175-f3e2-49a7-bff2-a03ab9d9819a	2025-12-19 08:48:54.452418	2025-12-19 08:48:54.452418
1397	01c2c035-79f5-4039-8cc8-d8d12e019419	2025-12-19 08:49:19.308334	2025-12-19 08:49:19.308334
1398	fb5fd997-45f3-46d4-a133-02f4886c2fa5	2025-12-19 08:55:44.729834	2025-12-19 08:55:44.729834
1399	1f61e4a2-1269-47c1-a0d7-a0e893856b16	2025-12-19 08:57:09.065079	2025-12-19 08:57:09.065079
1400	b5cc9974-2c27-44d9-b196-f9f2fe3f73ce	2025-12-19 08:57:54.965292	2025-12-19 08:57:54.965292
1401	3fd386dd-5da0-4d77-8a66-580dfa7bcab5	2025-12-19 09:00:12.312376	2025-12-19 09:00:12.312376
1402	14b53bda-155d-4b33-88fb-e86ebfa1235e	2025-12-19 09:03:10.815404	2025-12-19 09:03:10.815404
1403	d10754a0-990b-4e75-be67-911aaa2a8484	2025-12-19 09:03:57.540398	2025-12-19 09:03:57.540398
1404	73e0fecd-5bb8-47bb-9710-c886db590695	2025-12-19 09:09:19.379651	2025-12-19 09:09:19.379651
1405	5cf3123b-47bf-4e55-a881-31888cb6601a	2025-12-19 09:10:45.592734	2025-12-19 09:10:45.592734
1406	1a5b1254-3e77-4f06-a9f2-b98acbfb2203	2025-12-19 09:17:41.797744	2025-12-19 09:17:41.797744
1407	d90e231f-57e6-4f87-acbd-539fa0f9b285	2025-12-19 09:18:38.617686	2025-12-19 09:18:38.617686
1408	2b37af4f-d637-4428-b95d-994005b7dda1	2025-12-19 09:32:08.980415	2025-12-19 09:32:08.980415
910	61ac02b7-f569-4d27-8e21-97d74fea7df0	2025-12-10 10:56:48.197039	2025-12-10 10:56:48.197039
915	8de9581c-952f-4959-a2de-c2cac7e3ba75	2025-12-10 20:42:38.742349	2025-12-10 20:42:38.742349
920	1c6ba669-afd1-439b-8b0e-42be76ea08fa	2025-12-11 11:59:06.602073	2025-12-11 11:59:06.602073
925	0ebfa598-57f3-478d-a4fe-dcd7bde1c6af	2025-12-12 00:02:18.981688	2025-12-12 00:02:18.981688
930	f11d4aaf-1fc3-4e11-b659-08b58e2dba4c	2025-12-12 15:56:40.261403	2025-12-12 15:56:40.261403
936	c930239e-5ba4-4673-b304-98fca25cb98f	2025-12-13 13:44:48.81346	2025-12-13 13:44:48.81346
942	6e53f103-8ad3-4336-b402-d1e97b4623fc	2025-12-13 15:59:18.534694	2025-12-13 15:59:18.534694
947	a0714f0f-d5bd-4a13-ba99-3a26a02aed11	2025-12-14 01:37:05.948078	2025-12-14 01:37:05.948078
952	32175036-dbfe-41f4-a887-12906ca18fe9	2025-12-14 15:04:27.124975	2025-12-14 15:04:27.124975
953	14028010-bcd0-4bf5-86f1-9bd7db52ec39	2025-12-14 15:04:31.301711	2025-12-14 15:04:31.301711
954	caac3992-db93-4090-8b8e-80495328e3d7	2025-12-14 15:04:38.067398	2025-12-14 15:04:38.067398
955	1bfc908d-3cfa-481a-ab6b-74d9de916af5	2025-12-14 15:04:41.461572	2025-12-14 15:04:41.461572
956	68c661e9-b5a4-42ee-a009-e141b5d0c042	2025-12-14 15:04:44.531571	2025-12-14 15:04:44.531571
961	313e70e2-be05-4d13-9d91-20a4b9fff194	2025-12-15 04:15:04.575261	2025-12-15 04:15:04.575261
966	02a11a65-5864-46c0-93ba-58fbb808050a	2025-12-15 10:49:47.468252	2025-12-15 10:49:47.468252
971	538fc4a0-9ac0-42b2-b2d1-77dd2052d7d2	2025-12-16 01:42:03.832573	2025-12-16 01:42:03.832573
976	8c2a4e31-24ad-4d24-94f3-95a4dab9b273	2025-12-16 06:11:59.172115	2025-12-16 06:11:59.172115
977	09844f37-7ffa-4407-9bd7-202c6c6fb169	2025-12-16 06:12:00.620611	2025-12-16 06:12:00.620611
982	e696deb0-75af-48ee-bba3-9afde230141a	2025-12-16 10:15:20.710681	2025-12-16 10:15:20.710681
987	6926d56c-0e7d-4c7f-802f-c31a65fc96ca	2025-12-16 17:41:58.542412	2025-12-16 17:41:58.542412
992	bbee910c-7d7a-4ddc-9a91-aae783ccc720	2025-12-16 18:02:20.192056	2025-12-16 18:02:20.192056
997	ad05538e-f5d7-4854-a591-8918576c3492	2025-12-16 18:19:24.430154	2025-12-16 18:19:24.430154
1003	a4b35e82-b30d-4161-ba5a-1d7a47149447	2025-12-16 18:23:38.730299	2025-12-16 18:23:38.730299
1008	da0292c3-d9dd-4916-a57a-83f5ccbd115c	2025-12-16 18:27:50.880109	2025-12-16 18:27:50.880109
1013	6407962c-4e64-4a5b-808e-9b224cc36023	2025-12-16 18:31:41.104269	2025-12-16 18:31:41.104269
1018	4b96c76b-6bd0-4688-832a-3dc85c405d88	2025-12-16 19:47:13.24725	2025-12-16 19:47:13.24725
1023	c808bfd4-a391-4d7d-b0b6-f9783db4d8ab	2025-12-16 20:44:59.873749	2025-12-16 20:44:59.873749
1028	0d6f9b87-2a5f-42b1-b61b-035d13994a83	2025-12-16 22:10:35.190359	2025-12-16 22:10:35.190359
1033	4bcc5105-759d-4af6-8a21-e2580219eb16	2025-12-16 23:24:24.544887	2025-12-16 23:24:24.544887
1039	75875584-7126-48e3-b30e-17bbc13fbd32	2025-12-17 00:38:26.816297	2025-12-17 00:38:26.816297
1044	7e36eafd-ea8f-4e03-b899-4302a05cdc7a	2025-12-17 02:18:23.422013	2025-12-17 02:18:23.422013
1049	9cf4a24d-7d4d-4159-8e2d-c8f5cbb00158	2025-12-17 03:02:29.599348	2025-12-17 03:02:29.599348
1054	406858c7-70b3-454a-ac0f-51ad7e94e33a	2025-12-17 03:30:58.574037	2025-12-17 03:30:58.574037
1060	5bb68906-6205-45f1-9743-022235734ed0	2025-12-17 04:25:34.984533	2025-12-17 04:25:34.984533
1065	c61a14a6-9bd8-4a89-b07f-10748de0f5fa	2025-12-17 04:57:54.027262	2025-12-17 04:57:54.027262
1070	599f944f-4d5f-44bd-ae7a-2461d2960f92	2025-12-17 05:27:24.679952	2025-12-17 05:27:24.679952
1075	5c962cc9-0a9c-42eb-bfbd-d8c108151267	2025-12-17 06:56:19.584917	2025-12-17 06:56:19.584917
1081	833da473-a1cc-444d-9d17-31151a62ff6f	2025-12-17 06:56:40.916924	2025-12-17 06:56:40.916924
1082	c9bb2d63-fc52-4e6b-8714-6e5d517ea908	2025-12-17 06:56:41.414083	2025-12-17 06:56:41.414083
1088	dab1289b-7266-4498-893a-62c9fd46c3f5	2025-12-17 13:00:26.055775	2025-12-17 13:00:26.055775
1093	a6d8083b-9468-41e6-a8e4-4e7b328c1aa8	2025-12-17 14:14:04.514711	2025-12-17 14:14:04.514711
1098	b756ab97-8410-450b-8d80-019f1dcffb38	2025-12-17 14:44:18.922943	2025-12-17 14:44:18.922943
1103	13825874-07f8-46ab-9598-57cd8ce26bf0	2025-12-17 14:51:04.689917	2025-12-17 14:51:04.689917
1108	c78f4660-69e9-4a49-98d1-0f7628901f65	2025-12-17 15:06:05.474501	2025-12-17 15:06:05.474501
1113	d11f4a4e-abf1-4b6e-b2f4-c2eaa375ae15	2025-12-17 15:18:09.090831	2025-12-17 15:18:09.090831
1118	c453fab6-8ef7-460b-9e84-0e8c43e7f232	2025-12-17 15:29:32.630003	2025-12-17 15:29:32.630003
1123	9bc787bf-38a9-462b-a889-ab8c8a4e00f3	2025-12-17 15:45:08.576714	2025-12-17 15:45:08.576714
1129	46238865-984c-4f92-b142-41a6aedf944e	2025-12-17 15:53:08.584654	2025-12-17 15:53:08.584654
1134	49c7342d-27e0-4d1c-a210-b39c726c8b29	2025-12-17 16:02:45.782107	2025-12-17 16:02:45.782107
1139	a3c7e5ea-7694-4e75-986b-768455edc4ad	2025-12-17 16:23:13.388978	2025-12-17 16:23:13.388978
1145	62a107bc-cc9a-4e08-bd55-958561426945	2025-12-17 16:40:07.467688	2025-12-17 16:40:07.467688
1150	5b7c80ea-4cfd-4d9f-b256-d0bf96b3d778	2025-12-17 17:13:47.975314	2025-12-17 17:13:47.975314
1155	0a921554-a494-4f6b-96aa-024afcc090cd	2025-12-17 17:22:38.287435	2025-12-17 17:22:38.287435
1160	0c02f9fd-6202-46ce-a4d7-b96531fc0a07	2025-12-17 17:36:25.809548	2025-12-17 17:36:25.809548
1165	032cd839-8778-4bce-a060-28f3330ad246	2025-12-17 18:15:44.094895	2025-12-17 18:15:44.094895
1171	da617275-a224-46e7-a977-143c438423d9	2025-12-17 18:33:25.901476	2025-12-17 18:33:25.901476
1176	da7e6e8d-fa94-43a5-b04a-60cace0ce60b	2025-12-17 21:56:01.355176	2025-12-17 21:56:01.355176
1181	7e29daea-c877-49c5-95ba-8363e53a512f	2025-12-17 22:48:35.021367	2025-12-17 22:48:35.021367
1186	eb80692f-afe8-4f15-b0c1-806fc497349c	2025-12-18 00:51:31.81369	2025-12-18 00:51:31.81369
1191	361d59bf-1303-40cb-a8e8-54e1695080fd	2025-12-18 01:56:19.970827	2025-12-18 01:56:19.970827
1196	250c2de7-c78b-40e5-89c7-ee0585e96833	2025-12-18 02:25:18.981061	2025-12-18 02:25:18.981061
1201	c69b9017-c7f7-40ee-92b8-c6a1276727eb	2025-12-18 03:19:44.047529	2025-12-18 03:19:44.047529
1206	b679caa9-b295-4009-b12b-da0bb9387c48	2025-12-18 04:31:12.639321	2025-12-18 04:31:12.639321
1211	4b75a3df-051f-44a2-b7c0-4f30146d70a2	2025-12-18 05:08:40.340502	2025-12-18 05:08:40.340502
1216	97b0204b-78ae-44bb-983a-a1e2383672cc	2025-12-18 05:53:57.820304	2025-12-18 05:53:57.820304
1221	15265605-72df-48d0-846f-19a9f67d3d07	2025-12-18 06:22:41.576451	2025-12-18 06:22:41.576451
1226	b0964d9f-bdf9-4862-8541-1ad124a5342a	2025-12-18 06:57:47.518012	2025-12-18 06:57:47.518012
1231	1e76f5b6-40c6-4326-b660-9b78262bf019	2025-12-18 07:33:30.219091	2025-12-18 07:33:30.219091
1236	512c755c-a79b-4b5c-a821-9a3def9e4556	2025-12-18 08:01:16.071108	2025-12-18 08:01:16.071108
1242	dd05bf91-f9ae-44b8-a06c-9e22c7154320	2025-12-18 08:13:51.835679	2025-12-18 08:13:51.835679
1245	ec7a43d8-0733-408a-88aa-f30e302b8706	2025-12-18 08:24:29.490095	2025-12-18 08:24:29.490095
1251	da28717e-1703-4635-b677-4278d8e0c3df	2025-12-18 09:00:49.477856	2025-12-18 09:00:49.477856
1257	f8d7b052-1e67-4911-835f-00a46f0da944	2025-12-18 09:50:33.419531	2025-12-18 09:50:33.419531
1263	7b4c5051-82e9-4e19-8221-a8b9c75edd02	2025-12-18 10:19:54.979627	2025-12-18 10:19:54.979627
1269	516e3ebf-4777-48e6-bfe2-8c2ff94caee2	2025-12-18 10:53:04.014962	2025-12-18 10:53:04.014962
1275	0cdfa16c-803a-4e93-9316-a31630e9752b	2025-12-18 11:22:10.024948	2025-12-18 11:22:10.024948
1282	9b0ef726-70fd-476d-a46f-1d72f6652f4a	2025-12-18 12:31:30.394226	2025-12-18 12:31:30.394226
1288	782b6292-9b57-493c-9cca-36e497a19d95	2025-12-18 14:14:25.097903	2025-12-18 14:14:25.097903
1294	1dd7b3c5-38f1-45dc-9958-dfef5117f224	2025-12-18 15:22:44.913518	2025-12-18 15:22:44.913518
1300	b67dd862-5ac1-408f-92b6-f59435e6375d	2025-12-18 16:20:21.387182	2025-12-18 16:20:21.387182
1307	9fbbd75f-1283-43ad-9c5d-85414601d4af	2025-12-18 17:08:08.877586	2025-12-18 17:08:08.877586
1313	f89acfec-5553-4a9d-9056-50e478730119	2025-12-18 18:15:24.16788	2025-12-18 18:15:24.16788
1319	62c5de06-4fa2-44a4-af2e-0bb78a1da960	2025-12-19 01:04:32.803011	2025-12-19 01:04:32.803011
1326	29f7ff60-738d-45be-bf08-d739eb0a1f7d	2025-12-19 02:33:04.996156	2025-12-19 02:33:04.996156
1332	5b77b96a-8561-4300-aba7-070939446b1f	2025-12-19 03:55:14.577498	2025-12-19 03:55:14.577498
1338	33fc3af0-ca4a-46ed-b000-db8a312c1363	2025-12-19 04:40:27.701108	2025-12-19 04:40:27.701108
1344	6980a418-0ad5-4945-b048-2f04d561cfdb	2025-12-19 05:08:03.194211	2025-12-19 05:08:03.194211
1350	808e7849-df00-48b5-a70c-e735651d44e0	2025-12-19 05:58:00.231994	2025-12-19 05:58:00.231994
911	b29d99ff-5b88-4517-8647-bf45ef8a86f0	2025-12-10 11:53:32.403277	2025-12-10 11:53:32.403277
916	70ed6ed7-1f35-49e3-8542-dd924f449f91	2025-12-11 00:09:40.217414	2025-12-11 00:09:40.217414
921	7e27817d-eb5b-41b8-90dd-f6c667d65aa4	2025-12-11 13:38:03.912051	2025-12-11 13:38:03.912051
926	aaecfae4-b410-413e-85e5-61c3631ba8b7	2025-12-12 00:08:13.617219	2025-12-12 00:08:13.617219
931	2e642f90-4aa8-47a9-91cd-5af9efa55a94	2025-12-12 18:52:31.295516	2025-12-12 18:52:31.295516
932	a097b7fa-e707-478f-b633-423499e41e46	2025-12-12 18:52:32.050992	2025-12-12 18:52:32.050992
937	32a31134-ea06-4818-bedc-09f4e7e2fa28	2025-12-13 14:05:49.136602	2025-12-13 14:05:49.136602
943	42086070-1430-40b4-a831-a3d06f4656d0	2025-12-13 15:59:38.660466	2025-12-13 15:59:38.660466
948	34e43288-7572-459c-a415-0699880a01f1	2025-12-14 04:37:29.996737	2025-12-14 04:37:29.996737
957	50a83e88-848e-4e87-b9ae-59701c93e26d	2025-12-14 18:01:01.858972	2025-12-14 18:01:01.858972
962	705bc9fa-7338-4558-ae48-ae98ad34bc25	2025-12-15 04:15:07.059151	2025-12-15 04:15:07.059151
967	293c5067-59b2-48ca-b8ba-ae25aafac049	2025-12-15 13:53:10.029161	2025-12-15 13:53:10.029161
972	6e87f820-e67c-4977-bc29-209f58b5a4af	2025-12-16 03:13:46.865608	2025-12-16 03:13:46.865608
978	bbd3c70b-91c1-492a-ae6c-db32c124ca90	2025-12-16 06:12:01.612443	2025-12-16 06:12:01.612443
983	1abc3ffc-1266-4abe-9284-f9a1a4bc00bb	2025-12-16 10:18:33.902135	2025-12-16 10:18:33.902135
988	1164af0e-c006-4717-a25f-1492db05da5c	2025-12-16 17:45:22.166132	2025-12-16 17:45:22.166132
993	5fc19413-f27e-49f1-b990-a25d86a03b87	2025-12-16 18:03:22.570245	2025-12-16 18:03:22.570245
998	97713902-96cf-47e4-b88d-47abad187e06	2025-12-16 18:20:05.833262	2025-12-16 18:20:05.833262
1004	4c85340a-dd62-4bee-9723-f2aab5b2ecc7	2025-12-16 18:23:54.458133	2025-12-16 18:23:54.458133
1009	e4e48db1-4d25-4912-909e-dd5fbaa86ffe	2025-12-16 18:28:57.623747	2025-12-16 18:28:57.623747
1014	64d54c0c-aa2e-415c-905e-ab67b8e9658b	2025-12-16 18:32:43.650236	2025-12-16 18:32:43.650236
1019	474c588c-63d2-499a-854d-7275f47cf0a3	2025-12-16 20:14:30.454748	2025-12-16 20:14:30.454748
1024	ac2a93ae-45e9-4872-b809-1eb16c7d6aed	2025-12-16 20:52:01.864104	2025-12-16 20:52:01.864104
1029	a2fba00d-9720-421e-9558-a9fa4399328e	2025-12-16 22:27:54.504706	2025-12-16 22:27:54.504706
1034	03bccc70-7080-4c8e-9e26-fbcac47f830e	2025-12-16 23:38:53.896933	2025-12-16 23:38:53.896933
1040	3894f867-7afe-42fb-a71a-47ba6cff63c4	2025-12-17 00:39:45.094688	2025-12-17 00:39:45.094688
1045	f4c6510d-f3de-4583-bfb0-9f8514c9da2a	2025-12-17 02:25:15.025589	2025-12-17 02:25:15.025589
1050	e5fdd412-8bf2-4c02-8c5a-1c289db2d8c6	2025-12-17 03:05:43.914953	2025-12-17 03:05:43.914953
1055	933e63e4-0f10-4c7e-8776-6b4339de377a	2025-12-17 04:07:08.833891	2025-12-17 04:07:08.833891
1061	c18511ee-6dcd-4402-842e-b17292ec5a99	2025-12-17 04:29:40.217156	2025-12-17 04:29:40.217156
1066	88532b1c-a14b-4131-86c8-563edbab817f	2025-12-17 05:05:12.24954	2025-12-17 05:05:12.24954
1071	c90014d4-2678-44da-b4ae-9b65d1b435a6	2025-12-17 05:30:07.895857	2025-12-17 05:30:07.895857
1076	1268a4f3-16c9-472a-947d-df5252210ebe	2025-12-17 06:56:19.620688	2025-12-17 06:56:19.620688
1083	54296ac3-e49c-4687-86e2-0eb98abd97c2	2025-12-17 07:00:59.079921	2025-12-17 07:00:59.079921
1089	26c3df95-9588-499c-8765-9d34bc812c4c	2025-12-17 13:32:15.321515	2025-12-17 13:32:15.321515
1094	1669a26e-e5e8-4636-8229-75eef464a36d	2025-12-17 14:26:20.989925	2025-12-17 14:26:20.989925
1099	b10f8a7b-a9ea-40b8-961f-c720fb73befb	2025-12-17 14:45:23.526777	2025-12-17 14:45:23.526777
1104	2016da80-d514-4979-9ca1-cf7c2437bdbb	2025-12-17 14:53:44.280258	2025-12-17 14:53:44.280258
1109	528d9739-3007-4ab8-9874-89780fe9580c	2025-12-17 15:08:37.326243	2025-12-17 15:08:37.326243
1114	0814cca2-f703-4f64-afce-9c7bc1f61eaa	2025-12-17 15:22:15.853141	2025-12-17 15:22:15.853141
1119	9117c27c-b733-43ba-b246-3f63496abaf3	2025-12-17 15:31:58.77687	2025-12-17 15:31:58.77687
1124	0e4a4ec7-c81e-4d6c-8892-bef60b11631b	2025-12-17 15:46:57.69205	2025-12-17 15:46:57.69205
1130	65d385b0-1318-4e39-a24b-3a6e92094607	2025-12-17 15:53:17.482695	2025-12-17 15:53:17.482695
1135	ea4f7a21-6516-4296-aade-35dd6381488b	2025-12-17 16:09:40.123105	2025-12-17 16:09:40.123105
1140	93309fc3-23b4-437e-ae88-a8a9b5503e55	2025-12-17 16:30:10.919681	2025-12-17 16:30:10.919681
1146	0bb82bd4-685c-407d-a176-4da604ecab79	2025-12-17 16:47:58.625842	2025-12-17 16:47:58.625842
1151	92cd51f3-49ce-481d-85e3-9dc07290b7ea	2025-12-17 17:16:01.48585	2025-12-17 17:16:01.48585
1156	baef55d6-d2c5-45ae-94a9-287cf7c45f64	2025-12-17 17:25:07.978094	2025-12-17 17:25:07.978094
1161	85ed1bf8-140b-4fb5-8484-96729aaa7b9f	2025-12-17 17:38:50.514234	2025-12-17 17:38:50.514234
1166	2280f6a5-de12-4688-9625-17515091e7bf	2025-12-17 18:15:48.849765	2025-12-17 18:15:48.849765
1167	5f31acf2-5e35-4702-ac3a-bc0e9ee2888a	2025-12-17 18:15:57.120497	2025-12-17 18:15:57.120497
1172	48d072ff-b785-4d70-8669-303920ba651b	2025-12-17 18:52:25.248206	2025-12-17 18:52:25.248206
1177	7e86dcf0-acfb-4720-96a4-8dc8a66cef00	2025-12-17 22:01:52.899407	2025-12-17 22:01:52.899407
1182	94d54809-d5d8-434a-b5d6-1ec38616e84b	2025-12-17 23:17:33.922177	2025-12-17 23:17:33.922177
1187	0e4c979b-591b-4b21-a1ed-ddfe418b450f	2025-12-18 00:52:55.414112	2025-12-18 00:52:55.414112
1192	84cc9038-d4c9-4237-9bb8-0941a57d69d7	2025-12-18 02:01:42.953052	2025-12-18 02:01:42.953052
1197	3e780a27-8f08-42b9-ba9a-00dcf9828bd8	2025-12-18 02:26:29.41446	2025-12-18 02:26:29.41446
1202	6674955f-89b0-4942-b8d2-9378a2a538dc	2025-12-18 03:45:33.698313	2025-12-18 03:45:33.698313
1207	0bb3ef5d-525f-425a-bcce-436ac30838d0	2025-12-18 04:39:01.668195	2025-12-18 04:39:01.668195
1212	fadc22b6-50e2-41ef-b08c-07cc9797361f	2025-12-18 05:34:59.120218	2025-12-18 05:34:59.120218
1217	94209491-d3c2-4727-b9c7-ed5d7ebb54fc	2025-12-18 05:55:05.487167	2025-12-18 05:55:05.487167
1222	b823189c-dc7c-45f8-8a72-8e6fe8aa37c9	2025-12-18 06:42:07.186735	2025-12-18 06:42:07.186735
1227	20ee8cfc-7406-4fca-ac75-5ba5cd6f4021	2025-12-18 07:02:16.062283	2025-12-18 07:02:16.062283
1232	1fa61680-eb47-4db4-a1a7-b037791e1c8e	2025-12-18 07:50:50.340612	2025-12-18 07:50:50.340612
1237	3943e91e-3f81-4d20-ab89-c9b9f29a2c7d	2025-12-18 08:01:44.748295	2025-12-18 08:01:44.748295
1246	adc7b582-5fe0-4c38-bfad-4ad7bd97a6a2	2025-12-18 08:25:40.124158	2025-12-18 08:25:40.124158
1252	4a8f0e35-59e4-43a8-ad90-70101a3c7f62	2025-12-18 09:04:01.261214	2025-12-18 09:04:01.261214
1258	026d5b14-cc5a-43d8-91e1-06b1c2301300	2025-12-18 09:52:50.737423	2025-12-18 09:52:50.737423
1264	9e151965-ce44-4640-ad6d-f7fb7642e846	2025-12-18 10:23:58.641053	2025-12-18 10:23:58.641053
1270	3d8d78bc-0d1b-4d21-9113-bb598aecea4b	2025-12-18 11:08:49.944347	2025-12-18 11:08:49.944347
1276	fae06e3c-71a1-4350-b250-3564a69105d8	2025-12-18 11:31:52.080311	2025-12-18 11:31:52.080311
1283	5145ec97-e843-44e2-a229-efe503502832	2025-12-18 12:34:55.105949	2025-12-18 12:34:55.105949
1289	dcb10dcc-897d-4d09-adaa-b9ab958a8bf9	2025-12-18 14:23:08.839154	2025-12-18 14:23:08.839154
1295	5edfba13-0238-4ac9-8106-bf30fbb291ca	2025-12-18 15:32:42.578114	2025-12-18 15:32:42.578114
1301	ff5cf8a5-9e75-4eda-842a-05e2ca601459	2025-12-18 16:28:38.693369	2025-12-18 16:28:38.693369
1308	a31d7c7c-c720-4f55-a6d7-28d3d2531c7c	2025-12-18 17:24:36.386523	2025-12-18 17:24:36.386523
1314	c0e259e2-f7ea-42e6-8bdc-3e4f0a88a2e7	2025-12-18 20:17:01.129632	2025-12-18 20:17:01.129632
1320	83556673-8e34-4283-8922-9f320409a5c3	2025-12-19 01:04:48.493944	2025-12-19 01:04:48.493944
1327	2c9a878f-3679-4356-8255-3c26acd8c860	2025-12-19 03:20:29.029612	2025-12-19 03:20:29.029612
1333	e6103514-534a-4c3d-bb58-b61fd367aa6e	2025-12-19 04:04:28.280328	2025-12-19 04:04:28.280328
1339	2a526170-8ccf-49ca-aa6c-859a23018611	2025-12-19 04:41:17.177514	2025-12-19 04:41:17.177514
1345	6ae861d0-9f38-4b80-9896-862ec2d36e5a	2025-12-19 05:16:54.162819	2025-12-19 05:16:54.162819
1351	318962db-3797-4271-ae95-3a715b02b05e	2025-12-19 06:01:24.297235	2025-12-19 06:01:24.297235
1356	6172ad74-018d-4289-8226-fc015a3826c6	2025-12-19 06:11:31.461468	2025-12-19 06:11:31.461468
1361	a6806ccd-ac79-4105-800f-f609c2214315	2025-12-19 06:40:07.116579	2025-12-19 06:40:07.116579
1366	e2b024bb-6e6d-4750-9e60-a5f5b7c34d5a	2025-12-19 06:49:39.919187	2025-12-19 06:49:39.919187
1370	5fb66a52-562f-47d5-a756-c431ceec78ba	2025-12-19 06:58:52.304831	2025-12-19 06:58:52.304831
1373	61e6455b-5bbf-4175-8a27-852c8cb58ae4	2025-12-19 07:12:26.551702	2025-12-19 07:12:26.551702
912	8237e2f9-0159-44e0-9c9b-e7139703803e	2025-12-10 16:43:08.393406	2025-12-10 16:43:08.393406
917	b9415f8b-b76d-4a67-b8d0-a1ce9da2b345	2025-12-11 06:45:43.012295	2025-12-11 06:45:43.012295
922	13492897-dd51-447d-aa3b-c9f869c7e577	2025-12-11 15:26:27.600233	2025-12-11 15:26:27.600233
927	03577c10-14af-4ec1-bf30-3d8de5baf9c2	2025-12-12 01:31:36.639393	2025-12-12 01:31:36.639393
933	458811ab-00d4-457c-80dd-02e1af7ef380	2025-12-12 18:53:15.082408	2025-12-12 18:53:15.082408
938	49d27e1b-21cd-4a97-a366-5dddf4ca7e3c	2025-12-13 14:31:21.107373	2025-12-13 14:31:21.107373
939	204a63e1-acc0-4f38-a107-dafcd1a4032d	2025-12-13 14:31:23.180267	2025-12-13 14:31:23.180267
944	8ddc1182-3190-4ca4-a965-39507934c76e	2025-12-13 19:04:41.161844	2025-12-13 19:04:41.161844
949	aee8994b-1112-4e77-97ca-07e54706f4b9	2025-12-14 06:16:33.637614	2025-12-14 06:16:33.637614
958	c7538d06-efb5-444f-9f0f-ae2b81ca1225	2025-12-15 02:08:53.713596	2025-12-15 02:08:53.713596
963	8563ad46-606e-4fe2-b1fc-6845d2f8bd7a	2025-12-15 04:47:15.09378	2025-12-15 04:47:15.09378
968	cca9e112-d40c-435f-9aad-2471d98b5699	2025-12-15 23:09:08.823221	2025-12-15 23:09:08.823221
973	40afe31a-1eea-4ae9-9285-4287b2f3835b	2025-12-16 06:06:26.083221	2025-12-16 06:06:26.083221
979	f001f707-e2b9-49b9-9eba-1b156d8b9ab1	2025-12-16 06:13:31.351062	2025-12-16 06:13:31.351062
984	a92283fc-e993-4736-a33e-085d3db993a4	2025-12-16 14:11:02.695743	2025-12-16 14:11:02.695743
989	2fcca35b-e4fb-4682-bba5-c7ad40583962	2025-12-16 17:57:48.003849	2025-12-16 17:57:48.003849
994	17dfccb6-971d-4375-96bd-007675a54094	2025-12-16 18:05:31.76477	2025-12-16 18:05:31.76477
999	6d50e50e-30cf-48a5-80fc-7cc2ea86127b	2025-12-16 18:20:59.171379	2025-12-16 18:20:59.171379
1005	e1ddd012-c045-416e-b1b6-cba3335019b0	2025-12-16 18:25:36.155479	2025-12-16 18:25:36.155479
1010	945c600e-c8bd-43ab-80b2-3dd5c182398b	2025-12-16 18:29:15.216147	2025-12-16 18:29:15.216147
1015	6e5976e8-554b-4d88-85cd-8a8f0e2cf7eb	2025-12-16 18:38:21.766482	2025-12-16 18:38:21.766482
1020	f0760f25-c011-4f95-952e-c6f6e6657498	2025-12-16 20:28:11.9307	2025-12-16 20:28:11.9307
1025	99ea90ae-035d-48d4-9d91-0d0c309fad42	2025-12-16 21:28:22.898424	2025-12-16 21:28:22.898424
1030	ede0d85b-39dd-4d65-89b3-acb82fa3c7fc	2025-12-16 22:33:43.130673	2025-12-16 22:33:43.130673
1035	43873641-eeb0-4336-8b47-4470efb818b8	2025-12-16 23:57:34.861128	2025-12-16 23:57:34.861128
1041	885036cd-01c6-46dd-96d4-133872c1d4ae	2025-12-17 01:06:24.953748	2025-12-17 01:06:24.953748
1046	8cbe49ea-9384-46db-814b-845d3ff32b49	2025-12-17 02:49:20.27401	2025-12-17 02:49:20.27401
1051	112f078b-581b-40bd-85cb-f180413d8ea8	2025-12-17 03:12:57.376041	2025-12-17 03:12:57.376041
1056	a0d76579-011e-4f55-87e8-fe0afb050584	2025-12-17 04:07:40.123498	2025-12-17 04:07:40.123498
1057	0d007aff-8629-440b-8fb1-fda15e2a4d37	2025-12-17 04:07:53.612301	2025-12-17 04:07:53.612301
1062	cbfd920b-871b-44f7-8bc8-cf6d0c6a6bfb	2025-12-17 04:36:30.321634	2025-12-17 04:36:30.321634
1067	0d7f9ac7-a264-4527-9a08-15ef128b44e5	2025-12-17 05:10:38.249131	2025-12-17 05:10:38.249131
1072	fb1f8884-232d-4c1d-8f7a-68efc1f9888e	2025-12-17 05:35:33.343652	2025-12-17 05:35:33.343652
1077	29455fe1-2062-4380-a61b-6d736d24ad2c	2025-12-17 06:56:20.119577	2025-12-17 06:56:20.119577
1078	c0afae1c-e7fc-4030-8273-ede0a36a313e	2025-12-17 06:56:21.352444	2025-12-17 06:56:21.352444
1084	0ae49022-92fa-4f5c-a75f-e16f367d8c94	2025-12-17 09:11:55.772536	2025-12-17 09:11:55.772536
1090	1226e463-56e1-4c05-b0be-3f620d4eb9b5	2025-12-17 13:53:40.356793	2025-12-17 13:53:40.356793
1095	367bd677-46b5-4943-8f18-bc19bdeb3fb6	2025-12-17 14:35:07.397792	2025-12-17 14:35:07.397792
1100	be64204b-f1a0-4d71-99f0-94e9dc9778c1	2025-12-17 14:46:59.485811	2025-12-17 14:46:59.485811
1105	f85a428a-e1db-4e54-96c5-405d680dbd40	2025-12-17 14:58:44.248353	2025-12-17 14:58:44.248353
1110	e83db665-d002-4085-a4f4-e00f9107d37e	2025-12-17 15:09:06.807561	2025-12-17 15:09:06.807561
1115	ed993112-8c23-4786-a6ac-5c2f8b897fb0	2025-12-17 15:22:45.012206	2025-12-17 15:22:45.012206
1120	086a06f1-2e94-47a1-b47f-781b57f42262	2025-12-17 15:34:00.60448	2025-12-17 15:34:00.60448
1125	6e083b6a-7181-47fb-bf06-0a816b5586eb	2025-12-17 15:47:47.164939	2025-12-17 15:47:47.164939
1126	39cd49e7-0c76-4af0-9106-ec634b5a8c65	2025-12-17 15:47:50.005506	2025-12-17 15:47:50.005506
1131	580cf927-aac8-45b1-b88c-cb9de7d6bcce	2025-12-17 15:55:10.710945	2025-12-17 15:55:10.710945
1136	64492896-6e54-42eb-8ba3-beb86748ce1a	2025-12-17 16:14:44.718065	2025-12-17 16:14:44.718065
1141	57e25194-658e-44a4-893c-0ec4e755eeba	2025-12-17 16:30:49.675803	2025-12-17 16:30:49.675803
1147	971ec044-d151-41ae-b1b3-20408cbbb0f9	2025-12-17 16:52:48.736001	2025-12-17 16:52:48.736001
1152	89b2a6fd-9c30-410c-9f21-6ca280ebcfc8	2025-12-17 17:18:45.004369	2025-12-17 17:18:45.004369
1157	a6e50a3d-f70d-43a6-9b12-3489387b7d91	2025-12-17 17:27:24.285443	2025-12-17 17:27:24.285443
1162	a8f1500b-51fc-444f-894b-9ad509dab160	2025-12-17 17:40:06.497589	2025-12-17 17:40:06.497589
1168	cd092e03-4c5e-4ef6-98cc-2ccc88570478	2025-12-17 18:21:53.147418	2025-12-17 18:21:53.147418
1173	01166b15-f3ba-4342-920a-41173616556f	2025-12-17 20:22:49.466806	2025-12-17 20:22:49.466806
1178	d0af10f4-8dfc-4c64-84d0-c3e7af1c28d8	2025-12-17 22:09:43.536854	2025-12-17 22:09:43.536854
1183	545547b0-ef65-40ee-ba7e-a5dbdf0fda4b	2025-12-17 23:24:52.05633	2025-12-17 23:24:52.05633
1188	bd672c57-4716-40c5-ad9f-85c4ef221c58	2025-12-18 01:13:15.177773	2025-12-18 01:13:15.177773
1193	8534d00d-daaf-443a-b2e2-9ab307881d70	2025-12-18 02:12:18.886651	2025-12-18 02:12:18.886651
1198	9de1bb86-5657-447c-86d8-08a5f39017ee	2025-12-18 02:29:45.737951	2025-12-18 02:29:45.737951
1203	b53a1181-f303-4ae8-86e7-69775c113321	2025-12-18 03:48:17.482424	2025-12-18 03:48:17.482424
1208	9a6cb9e7-d651-4d82-a389-f6fa0d2d342c	2025-12-18 04:45:12.129958	2025-12-18 04:45:12.129958
1213	1dcc1b3a-0602-415c-ae80-06bd3c74a395	2025-12-18 05:39:18.058202	2025-12-18 05:39:18.058202
1218	9223129a-0a5e-49f5-91f9-49cbbe6d9239	2025-12-18 06:09:47.264275	2025-12-18 06:09:47.264275
1223	67f4d2ae-b272-4f43-90ff-1210b2ef238b	2025-12-18 06:51:57.651913	2025-12-18 06:51:57.651913
1228	2e160219-fb16-416c-8142-426a3f0b026d	2025-12-18 07:06:42.077925	2025-12-18 07:06:42.077925
1233	56d8671d-a9c8-4f56-a7b9-0c7a36484156	2025-12-18 07:56:11.152571	2025-12-18 07:56:11.152571
1238	8db19de8-fa08-4b1f-8e31-2fb592bb36a8	2025-12-18 08:05:14.958114	2025-12-18 08:05:14.958114
1247	2a4fb431-28bd-4d6e-8a21-7b3eb641aa06	2025-12-18 08:44:09.610725	2025-12-18 08:44:09.610725
1253	4b211a6f-e069-4331-9c31-6486665a1016	2025-12-18 09:07:23.642826	2025-12-18 09:07:23.642826
1259	b32426a8-4a28-4480-af10-3f7cefd08670	2025-12-18 09:56:57.265345	2025-12-18 09:56:57.265345
1265	49d5902a-efa9-49b3-acfb-0b899cf4b7b7	2025-12-18 10:37:06.348021	2025-12-18 10:37:06.348021
1271	ee0b1089-186f-4f82-8a82-e2f5d32bf666	2025-12-18 11:09:45.916897	2025-12-18 11:09:45.916897
1277	3a53fb4c-d4ff-42fd-9eb5-4e702e224198	2025-12-18 11:41:28.210957	2025-12-18 11:41:28.210957
1278	e3bc98bc-333c-4e24-84e8-704b4dd50cce	2025-12-18 11:41:34.236227	2025-12-18 11:41:34.236227
1284	11aa46ad-e15d-443a-9a74-af3aca7153e7	2025-12-18 13:44:50.431326	2025-12-18 13:44:50.431326
1290	4ca84a43-71c7-4094-8665-ebc0e655aa52	2025-12-18 14:24:31.175224	2025-12-18 14:24:31.175224
1296	37f88248-ad82-4232-81e1-780cc05fd064	2025-12-18 15:34:16.864874	2025-12-18 15:34:16.864874
1302	2b7955e8-3e03-4d72-ab07-32aa717e87a4	2025-12-18 16:34:46.627314	2025-12-18 16:34:46.627314
1309	f4506759-adc5-4f26-bf78-383bd800d0cf	2025-12-18 17:31:40.483837	2025-12-18 17:31:40.483837
1315	d7ed1fe4-7329-4e36-897e-aa2353839090	2025-12-18 21:36:48.066606	2025-12-18 21:36:48.066606
1321	efe6b0d1-aced-49c0-bac5-c5097f26609b	2025-12-19 01:22:57.157367	2025-12-19 01:22:57.157367
1328	536e6bd1-75cd-44a3-a8c1-940279dd21d2	2025-12-19 03:22:12.430992	2025-12-19 03:22:12.430992
1334	aec3c51e-de36-49c3-85f5-450eeb19ab2a	2025-12-19 04:10:02.270164	2025-12-19 04:10:02.270164
1340	da285cc3-ab03-471a-9848-55b5237c59f9	2025-12-19 04:43:45.532687	2025-12-19 04:43:45.532687
1346	d2e128dc-c41c-457b-9b65-44c0ce701453	2025-12-19 05:29:19.151555	2025-12-19 05:29:19.151555
1352	3b47387b-bca3-4495-bc44-6a7055f9748d	2025-12-19 06:02:41.335192	2025-12-19 06:02:41.335192
1357	cf9ee156-f07e-4e78-93bb-23fab4e94a95	2025-12-19 06:14:05.067527	2025-12-19 06:14:05.067527
1362	6f7d85bb-50ef-411f-ac3b-aaa9220ffcd4	2025-12-19 06:42:26.653709	2025-12-19 06:42:26.653709
913	3814fe73-afd5-413f-9a7c-719d4502c25d	2025-12-10 19:58:15.952521	2025-12-10 19:58:15.952521
918	eef2c85a-96d7-4829-808c-a9e4d8a9e70b	2025-12-11 06:48:26.502854	2025-12-11 06:48:26.502854
923	1cfdcfbc-471b-4aa3-afcb-0abda547f651	2025-12-11 15:27:53.311858	2025-12-11 15:27:53.311858
928	e3e11d3a-c0bf-4bf4-873b-3aee95f3a788	2025-12-12 06:26:42.26163	2025-12-12 06:26:42.26163
934	6247ef9f-025a-4e80-8604-798cd9fc9561	2025-12-13 12:55:24.102187	2025-12-13 12:55:24.102187
940	140abea7-f936-48d5-9daa-be0038adc26d	2025-12-13 14:32:26.34829	2025-12-13 14:32:26.34829
945	714cfa08-b960-4760-8e0e-1e14d795e320	2025-12-13 19:55:04.831518	2025-12-13 19:55:04.831518
950	bfe1fae0-f9f3-40b9-88e0-f6c136811092	2025-12-14 09:35:12.104581	2025-12-14 09:35:12.104581
959	9453a3f4-d3af-483c-bd0f-a78a6187888a	2025-12-15 02:09:53.101847	2025-12-15 02:09:53.101847
964	e5ae3330-590e-4c53-85dd-99d2ca882369	2025-12-15 05:45:48.408153	2025-12-15 05:45:48.408153
969	e8368cc5-761f-4965-afbd-d1f80b9c2b4e	2025-12-16 00:13:32.080822	2025-12-16 00:13:32.080822
974	0a694f2a-99d7-4601-a974-1448e13bd294	2025-12-16 06:10:26.241798	2025-12-16 06:10:26.241798
980	156047a1-a2a4-4ec0-ac24-e8fdc86d69b9	2025-12-16 07:53:29.429982	2025-12-16 07:53:29.429982
985	b18c926f-17d4-4562-b02c-bde38c5ae8c5	2025-12-16 14:22:26.233502	2025-12-16 14:22:26.233502
990	7e9671b0-a7fd-4efd-9082-46fdb41ad918	2025-12-16 18:00:18.812708	2025-12-16 18:00:18.812708
995	f51718c0-fbcb-4705-83e9-6b0e1b588428	2025-12-16 18:12:02.109307	2025-12-16 18:12:02.109307
1000	dad0ed22-67e4-4938-a526-04c95891e0ba	2025-12-16 18:21:29.106244	2025-12-16 18:21:29.106244
1001	d7bf148e-b22e-44be-b543-5532b5af493d	2025-12-16 18:21:34.337987	2025-12-16 18:21:34.337987
1006	477b9b9d-2e80-4993-9558-3ea710773263	2025-12-16 18:26:28.279761	2025-12-16 18:26:28.279761
1011	02df2460-f69f-48a9-a069-78d4b5e61c5a	2025-12-16 18:29:44.854289	2025-12-16 18:29:44.854289
1016	44ac3d62-b35a-473f-9c16-fc52a4379b31	2025-12-16 19:01:09.461652	2025-12-16 19:01:09.461652
1021	80fddf57-8b2d-4998-be75-e91d933cbd54	2025-12-16 20:31:49.551196	2025-12-16 20:31:49.551196
1026	776761f2-f839-4c49-af9f-da8e1728f489	2025-12-16 21:42:38.082299	2025-12-16 21:42:38.082299
1031	b5baea00-ee33-42bd-b150-bd67a109cf80	2025-12-16 22:39:25.940979	2025-12-16 22:39:25.940979
1036	f685bad6-71e9-4171-b7d9-2d07b8dca913	2025-12-17 00:05:01.939511	2025-12-17 00:05:01.939511
1042	06b9d462-4f47-4864-9ce6-c6fb5d08a838	2025-12-17 02:07:12.356927	2025-12-17 02:07:12.356927
1047	37d01c05-bfa7-48e2-9e64-4468714f043d	2025-12-17 02:50:58.728285	2025-12-17 02:50:58.728285
1052	1fe62b4e-fb40-4fb7-9ff7-47ccccd44b33	2025-12-17 03:23:58.894095	2025-12-17 03:23:58.894095
1058	09755865-b87c-4f4f-ac63-7877e1793391	2025-12-17 04:09:39.090141	2025-12-17 04:09:39.090141
1063	4eb27b37-0e82-46a8-a3a1-f2c19852b386	2025-12-17 04:36:56.325773	2025-12-17 04:36:56.325773
1068	7a9b9646-f392-4d3f-b99e-cd33c2cfbb74	2025-12-17 05:16:04.254154	2025-12-17 05:16:04.254154
1073	71f54fff-e9bb-4dac-9bb5-e0c4f8ae56e8	2025-12-17 05:51:53.081141	2025-12-17 05:51:53.081141
1079	7bb1a255-3f0d-4c76-ab2c-f222c33626cd	2025-12-17 06:56:38.622722	2025-12-17 06:56:38.622722
1085	95188e79-28e4-41ea-b2e4-10c2bf432a6c	2025-12-17 10:12:43.011521	2025-12-17 10:12:43.011521
1086	42e62600-1271-4a55-b684-2a989c1707aa	2025-12-17 10:12:47.043239	2025-12-17 10:12:47.043239
1091	31941885-b93b-46b6-a6ab-a7e9718d52ae	2025-12-17 13:57:39.25349	2025-12-17 13:57:39.25349
1096	995c741c-bcaa-4819-9b3c-bdb7011c3bf2	2025-12-17 14:39:00.089995	2025-12-17 14:39:00.089995
1101	3ef21b1f-3a15-448b-a6b6-e87c15c1d896	2025-12-17 14:48:31.800686	2025-12-17 14:48:31.800686
1106	baf275eb-220d-4e75-8b2c-cb20dc8e5ebe	2025-12-17 15:00:52.645801	2025-12-17 15:00:52.645801
1111	fbeee71e-e4d5-4e9c-987e-c144d2fb14de	2025-12-17 15:13:21.621067	2025-12-17 15:13:21.621067
1116	a1c795ca-f484-46ab-b566-bc1e316750c8	2025-12-17 15:25:14.703503	2025-12-17 15:25:14.703503
1121	3900cb38-ea85-47d7-8c47-6d4e4939068a	2025-12-17 15:43:04.294515	2025-12-17 15:43:04.294515
1127	ad00fbea-299f-432f-a9a9-ff1293e4ad71	2025-12-17 15:49:22.504022	2025-12-17 15:49:22.504022
1132	20fab20b-0520-4667-9c32-2975d54589ce	2025-12-17 15:57:31.172424	2025-12-17 15:57:31.172424
1137	81fb7e80-6f60-43a5-8ba9-867d0d3e03cf	2025-12-17 16:16:24.973827	2025-12-17 16:16:24.973827
1142	15773ef9-3488-4c7e-a982-cadc92670d87	2025-12-17 16:33:13.825945	2025-12-17 16:33:13.825945
1143	1f7dc325-065f-490b-85a1-b40d2b642ffb	2025-12-17 16:33:19.311978	2025-12-17 16:33:19.311978
1148	2f4b33fc-b8ff-4f14-94fd-1303454731aa	2025-12-17 16:55:26.655116	2025-12-17 16:55:26.655116
1153	e2f51c07-d90a-46f5-a3f9-4fb765d33699	2025-12-17 17:19:16.956242	2025-12-17 17:19:16.956242
1158	85ee767d-5d85-49ba-8ba7-44cf034ff7ef	2025-12-17 17:28:30.215421	2025-12-17 17:28:30.215421
1163	f4b31b2b-f0b7-4df4-94c1-e52e6741a820	2025-12-17 17:52:33.960752	2025-12-17 17:52:33.960752
1169	5c0f7e11-710f-40ae-838f-6c6cc9bbdc81	2025-12-17 18:23:44.720303	2025-12-17 18:23:44.720303
1174	dba46fba-2c47-4394-9f91-43688b593683	2025-12-17 21:04:24.940266	2025-12-17 21:04:24.940266
1179	03a65ed4-21c9-4f40-bd59-4c822988ec83	2025-12-17 22:21:58.679819	2025-12-17 22:21:58.679819
1184	8d68cde5-6d96-4af4-92ce-66aa9e762505	2025-12-18 00:35:11.440861	2025-12-18 00:35:11.440861
1189	9272a2c2-2931-4226-983d-2ae7f2a8c7fc	2025-12-18 01:45:47.011377	2025-12-18 01:45:47.011377
1194	1f5e559d-e877-4874-a1d4-659894e7bb38	2025-12-18 02:14:42.018366	2025-12-18 02:14:42.018366
1199	44965df8-f60b-4609-bbc7-cd0a1e4ccde5	2025-12-18 03:03:58.009852	2025-12-18 03:03:58.009852
1204	b28de331-f93e-4977-8241-22f9613b9940	2025-12-18 03:52:08.823772	2025-12-18 03:52:08.823772
1209	15f7987b-fd48-43d9-8b2d-9edd354f0a0e	2025-12-18 05:03:04.628025	2025-12-18 05:03:04.628025
1214	1b4b603e-4eef-4f64-b16c-2490340de933	2025-12-18 05:47:22.52706	2025-12-18 05:47:22.52706
1219	7298adee-c4a7-445c-bfb3-41901aa05985	2025-12-18 06:19:14.748309	2025-12-18 06:19:14.748309
1224	ebc78548-e3a1-428a-b20d-567092c07afa	2025-12-18 06:53:52.782224	2025-12-18 06:53:52.782224
1229	b4469d23-2ca2-4306-90b6-818f9a0102e3	2025-12-18 07:24:41.166971	2025-12-18 07:24:41.166971
1234	3f43bfae-698d-4c0f-9abe-3761ab3a8a7c	2025-12-18 07:56:15.894646	2025-12-18 07:56:15.894646
1239	758bc1a6-09bc-4bda-bc96-44d539468eba	2025-12-18 08:12:18.365382	2025-12-18 08:12:18.365382
1240	48964605-5a9a-4627-ad8c-63d27503f36f	2025-12-18 08:12:23.037136	2025-12-18 08:12:23.037136
1248	dda596cc-ba0d-4877-8034-69f36125e669	2025-12-18 08:48:25.501822	2025-12-18 08:48:25.501822
1254	14b84ebc-4792-4f60-bdab-a5629662e2e1	2025-12-18 09:18:27.517979	2025-12-18 09:18:27.517979
1260	2c579169-4cd3-4cd0-b140-6b255b07bad4	2025-12-18 10:04:18.51271	2025-12-18 10:04:18.51271
1266	1ccf9657-c307-4526-9169-d312e55a958c	2025-12-18 10:44:13.987754	2025-12-18 10:44:13.987754
1272	7256159d-0ebc-4b01-af30-6a64d21b1c49	2025-12-18 11:11:29.17862	2025-12-18 11:11:29.17862
1279	408ddb4d-6cb8-4f4c-8092-652e44026ba5	2025-12-18 12:01:50.520392	2025-12-18 12:01:50.520392
1285	25a425b3-c0b0-4a08-97f4-3ab135f54f07	2025-12-18 13:48:51.048787	2025-12-18 13:48:51.048787
1291	a014b460-4f3c-4573-82e7-5faa98d98a7c	2025-12-18 14:45:24.775411	2025-12-18 14:45:24.775411
1297	e0c412e8-2f75-4da9-bfc7-d76deb844b46	2025-12-18 15:51:44.160585	2025-12-18 15:51:44.160585
1303	6f38abbf-ad35-434d-b226-c2868f9231d8	2025-12-18 16:38:13.227492	2025-12-18 16:38:13.227492
1310	aa5f60e8-752f-4329-9823-b1a5356fce97	2025-12-18 17:33:27.752393	2025-12-18 17:33:27.752393
1316	5f26d74d-a55e-4a61-b821-160af9ef4617	2025-12-18 23:28:46.284298	2025-12-18 23:28:46.284298
1322	e9b716bf-a5db-4db0-b586-e349772c7f7d	2025-12-19 01:44:26.005596	2025-12-19 01:44:26.005596
1329	5ba7a447-371e-45c6-ac5e-6d1ad85df349	2025-12-19 03:41:09.350334	2025-12-19 03:41:09.350334
1335	8d479a07-1f9b-4660-833c-d73389ccb447	2025-12-19 04:14:03.292379	2025-12-19 04:14:03.292379
1341	7dc77e77-8a97-4b36-912c-b4088d3dfeaf	2025-12-19 04:45:49.431482	2025-12-19 04:45:49.431482
1347	7e403ff2-5922-42b2-b4fd-bbfb45c2b421	2025-12-19 05:36:36.907195	2025-12-19 05:36:36.907195
1353	f1688d75-8ba9-47a0-9220-8eff997ab500	2025-12-19 06:05:00.870586	2025-12-19 06:05:00.870586
1358	191b45d0-27e6-484f-b35e-774b92cbc5ae	2025-12-19 06:16:19.399468	2025-12-19 06:16:19.399468
1363	6ffc2233-cb1e-4099-8353-375404e538ea	2025-12-19 06:44:56.112333	2025-12-19 06:44:56.112333
1367	ac290278-b999-4782-b76f-6eb0eed6ba64	2025-12-19 06:52:14.09442	2025-12-19 06:52:14.09442
914	0b69d0ca-016b-4099-bcc1-d4c2abc78a96	2025-12-10 20:18:06.609747	2025-12-10 20:18:06.609747
919	74d4b3f5-e5b2-48e2-a976-b9df787e128c	2025-12-11 07:30:46.278758	2025-12-11 07:30:46.278758
924	2fd165dd-2543-4f9e-addb-b171fe421d0d	2025-12-11 16:57:57.003157	2025-12-11 16:57:57.003157
929	2d416871-3620-4edf-a5cf-d25439815aac	2025-12-12 11:11:34.954392	2025-12-12 11:11:34.954392
935	08ed2b79-7470-4a0c-9d78-fb39f5213a47	2025-12-13 13:10:38.618838	2025-12-13 13:10:38.618838
941	73fd937a-4439-4cf2-bd92-c117928f46d2	2025-12-13 15:04:41.912121	2025-12-13 15:04:41.912121
946	b933d02a-6f86-4561-9432-b9692bac8787	2025-12-13 23:30:13.849748	2025-12-13 23:30:13.849748
951	a11b0164-57e2-4557-b8e8-47b26f6c4cea	2025-12-14 15:04:23.876384	2025-12-14 15:04:23.876384
960	57e8dfd5-dda7-4aea-baf0-bdd604b6c0ef	2025-12-15 02:14:46.069581	2025-12-15 02:14:46.069581
965	81fefd91-9166-42ab-85fa-356963d57d5e	2025-12-15 07:42:36.761548	2025-12-15 07:42:36.761548
970	e25c702d-fc2b-4ea8-815a-ecb32e31d5d4	2025-12-16 00:44:24.038623	2025-12-16 00:44:24.038623
975	5188a7fd-e2bd-40aa-b555-7de8332c4347	2025-12-16 06:11:59.085043	2025-12-16 06:11:59.085043
981	2c91011a-9d5a-4652-b77a-690543ca59bf	2025-12-16 08:52:22.714471	2025-12-16 08:52:22.714471
986	b50d2495-6a8d-47c0-99e0-cd04ea839c5d	2025-12-16 17:29:27.695249	2025-12-16 17:29:27.695249
991	6cfddbd8-de95-436f-b8a2-9322518a07a9	2025-12-16 18:00:21.931316	2025-12-16 18:00:21.931316
996	60684a20-e89c-4c85-a35a-da062f80f646	2025-12-16 18:18:53.330688	2025-12-16 18:18:53.330688
1002	27405484-b4b1-49b4-9977-ae88175417a3	2025-12-16 18:23:30.548307	2025-12-16 18:23:30.548307
1007	dae3713d-14d0-4a67-b808-52ad78d25745	2025-12-16 18:26:40.913707	2025-12-16 18:26:40.913707
1012	c3e269be-b245-4576-aba9-7073c04bf1a2	2025-12-16 18:30:04.444378	2025-12-16 18:30:04.444378
1017	8671a78a-6490-45d3-97e7-fb6a6af43592	2025-12-16 19:17:09.347887	2025-12-16 19:17:09.347887
1022	0f818c54-ba2a-48a0-a996-9544d5b07647	2025-12-16 20:42:06.549559	2025-12-16 20:42:06.549559
1027	a138937d-fe30-4503-a48f-4ffd74f97760	2025-12-16 22:06:17.646825	2025-12-16 22:06:17.646825
1032	12b83c24-cc7c-43aa-bf74-2d5a126e8f51	2025-12-16 23:19:02.310624	2025-12-16 23:19:02.310624
1037	02009c0f-e327-4695-875c-ddb9bef0f54b	2025-12-17 00:10:56.773358	2025-12-17 00:10:56.773358
1038	15e68a4d-2a86-449f-87fc-50fbdc63d2b6	2025-12-17 00:10:57.733868	2025-12-17 00:10:57.733868
1043	9380a12f-7a56-49af-bd61-3ffd1c355631	2025-12-17 02:09:17.972178	2025-12-17 02:09:17.972178
1048	3e72e158-10db-4c61-8f4d-5643130cd284	2025-12-17 02:51:53.287398	2025-12-17 02:51:53.287398
1053	5b3ea201-2597-490b-8dce-b5204d992c2d	2025-12-17 03:25:45.70296	2025-12-17 03:25:45.70296
1059	38494e76-b176-4f19-b399-2dbfa1e9868f	2025-12-17 04:19:57.169462	2025-12-17 04:19:57.169462
1064	3b62e476-61e8-4b63-8494-1563001b2fc6	2025-12-17 04:52:02.350338	2025-12-17 04:52:02.350338
1069	9ae563c3-c585-4788-a5c5-d4fa5b564750	2025-12-17 05:20:02.717235	2025-12-17 05:20:02.717235
1074	e5b03967-fe9e-40e9-8736-808ef026dbe1	2025-12-17 06:15:22.358681	2025-12-17 06:15:22.358681
1080	2e73672d-f70b-4b4b-adf6-6d0d3443efc2	2025-12-17 06:56:38.743869	2025-12-17 06:56:38.743869
1087	e7bf8635-6e28-4557-a281-cf14ead89df5	2025-12-17 11:43:25.302344	2025-12-17 11:43:25.302344
1092	3cfcb0b6-ae11-4682-a6a6-4032f476dc7d	2025-12-17 14:07:36.985562	2025-12-17 14:07:36.985562
1097	2be16d0f-21ae-4fae-9f3f-ecb206a8d2d1	2025-12-17 14:39:32.307376	2025-12-17 14:39:32.307376
1102	9df955ac-1b87-4d03-aaa0-9c291d76879c	2025-12-17 14:49:03.622684	2025-12-17 14:49:03.622684
1107	865ad573-5a78-4c1a-b2e0-a6d251ba6713	2025-12-17 15:03:26.713358	2025-12-17 15:03:26.713358
1112	77a41d21-09eb-4db3-9c1b-fcdded771455	2025-12-17 15:17:14.391347	2025-12-17 15:17:14.391347
1117	6fb09406-df4b-435a-b6b3-ab3260238e25	2025-12-17 15:29:14.834428	2025-12-17 15:29:14.834428
1122	25381d6f-240c-4f55-980a-c6e26d645c18	2025-12-17 15:44:08.555114	2025-12-17 15:44:08.555114
1128	d79206fe-8bfe-4750-ba1a-4afe46d5ae18	2025-12-17 15:51:29.87317	2025-12-17 15:51:29.87317
1133	32d67c18-21d0-494b-a5c2-4f51b66605cc	2025-12-17 15:59:41.371832	2025-12-17 15:59:41.371832
1138	6a663462-fa51-4e2b-bed0-bd3671b21ae4	2025-12-17 16:18:18.414475	2025-12-17 16:18:18.414475
1144	79cb2b9b-1f71-4514-a583-7e61bb9abc7e	2025-12-17 16:39:53.070678	2025-12-17 16:39:53.070678
1149	ebcfa455-ba5a-4c26-b741-a5eb871df116	2025-12-17 16:57:57.502728	2025-12-17 16:57:57.502728
1154	eb89f765-6882-4794-acc9-538670365f8b	2025-12-17 17:21:25.69062	2025-12-17 17:21:25.69062
1159	44ee9913-8fe0-4fd5-a0fd-99f002284527	2025-12-17 17:32:48.431798	2025-12-17 17:32:48.431798
1164	c30c2e24-8ebd-42a8-b7de-19e361400375	2025-12-17 17:53:30.874858	2025-12-17 17:53:30.874858
1170	bd2c3fb7-6d1c-4aea-9e0b-ae94f679215b	2025-12-17 18:26:17.864893	2025-12-17 18:26:17.864893
1175	c0b7c2d4-cb6e-4c50-bfb1-1d1dccca0a3f	2025-12-17 21:32:59.875691	2025-12-17 21:32:59.875691
1180	b89234ba-6e65-448f-bab9-5a5bd37e2cb7	2025-12-17 22:28:50.632556	2025-12-17 22:28:50.632556
1185	c0cc793d-a03c-4e3e-bef4-c0f8a2dace50	2025-12-18 00:46:22.748688	2025-12-18 00:46:22.748688
1190	da6f163f-bf26-4f8f-a3dd-de3fe9bf4fcf	2025-12-18 01:52:23.197267	2025-12-18 01:52:23.197267
1195	b45100d3-d4cc-46c6-a076-f6ec61e3081f	2025-12-18 02:17:31.320208	2025-12-18 02:17:31.320208
1200	c8e0a918-4b4f-4053-a61b-32d778e5e698	2025-12-18 03:11:46.190108	2025-12-18 03:11:46.190108
1205	74be8a40-3716-4a47-940c-4517cd069b64	2025-12-18 03:57:27.876526	2025-12-18 03:57:27.876526
1210	9bc402ed-027d-4159-84b8-3ba5cc66abb1	2025-12-18 05:06:45.315524	2025-12-18 05:06:45.315524
1215	42ab8206-d0bd-49d1-bcca-d24124823788	2025-12-18 05:48:11.872551	2025-12-18 05:48:11.872551
1220	1a5268cd-a5d2-41c4-be05-f4ce2442e21a	2025-12-18 06:20:04.317676	2025-12-18 06:20:04.317676
1225	373cb71b-eefa-483f-9433-6df0c1b4168b	2025-12-18 06:55:35.267908	2025-12-18 06:55:35.267908
1230	d062784a-e0de-477d-826e-a12079d58677	2025-12-18 07:28:03.4271	2025-12-18 07:28:03.4271
1235	da6d803b-9fd1-4c20-aa94-585212ed8c3c	2025-12-18 07:58:16.920701	2025-12-18 07:58:16.920701
1241	de37884a-f7fc-43c3-b2a9-46b2fb0d7da8	2025-12-18 08:13:51.054099	2025-12-18 08:13:51.054099
1249	b5faf60a-280c-48c8-a219-8a09deecb8aa	2025-12-18 08:50:12.391649	2025-12-18 08:50:12.391649
1255	508474be-3d78-4fa2-afc7-aab19f468fb0	2025-12-18 09:32:58.489783	2025-12-18 09:32:58.489783
1261	2576b718-a09e-4d0f-ae48-285762376486	2025-12-18 10:11:20.89153	2025-12-18 10:11:20.89153
1267	5d57793d-9a76-4af4-b00a-e1ab5f75a978	2025-12-18 10:45:10.759916	2025-12-18 10:45:10.759916
1273	a710d4ec-514e-4a0d-adec-ab21a6099d4a	2025-12-18 11:14:06.160396	2025-12-18 11:14:06.160396
1280	d5546f2b-bb59-476f-af4f-c759afc73fc2	2025-12-18 12:09:23.870445	2025-12-18 12:09:23.870445
1286	9d067ebc-4d0c-4a36-9aa2-60217fd45be4	2025-12-18 13:54:24.429919	2025-12-18 13:54:24.429919
1292	8369203e-9cce-443d-8d06-3e365ce1fdd0	2025-12-18 14:54:57.155106	2025-12-18 14:54:57.155106
1298	4d6d8afa-4333-4951-a538-76142ed49bec	2025-12-18 16:13:23.977074	2025-12-18 16:13:23.977074
1304	8c68caaf-8138-4a5d-8ac5-1bd5f0176c50	2025-12-18 16:49:17.028399	2025-12-18 16:49:17.028399
1305	6996bcce-e2e8-469f-884c-86587fba8f38	2025-12-18 16:49:24.158409	2025-12-18 16:49:24.158409
1311	017e77a6-f4bb-4bb0-8964-cfca180a81b2	2025-12-18 17:35:47.992504	2025-12-18 17:35:47.992504
1317	a37182b7-76df-434b-bb5d-342aaabb4689	2025-12-19 00:06:21.687669	2025-12-19 00:06:21.687669
1323	9a0610dc-9352-4146-9d16-f1c2f330a752	2025-12-19 01:48:57.105176	2025-12-19 01:48:57.105176
1330	aa83a93b-d7fa-40e7-8787-16192d2db3d2	2025-12-19 03:46:38.903286	2025-12-19 03:46:38.903286
1336	a1f7dc98-849f-40a8-8646-5f5f81965c58	2025-12-19 04:16:12.831629	2025-12-19 04:16:12.831629
1342	cac66769-61de-4dfe-8377-e04704302b9e	2025-12-19 04:57:10.745537	2025-12-19 04:57:10.745537
1348	e7849afa-5ed1-43d2-84fe-e023d16b5535	2025-12-19 05:39:04.065178	2025-12-19 05:39:04.065178
1354	68849154-9bf9-4f6e-aa58-d97f9da01de5	2025-12-19 06:08:32.38172	2025-12-19 06:08:32.38172
1359	73df3862-9198-40ab-b10e-4ca9e8566c0a	2025-12-19 06:25:11.586536	2025-12-19 06:25:11.586536
1364	a2be53f8-16e4-4a34-aaa6-172c3ea8e4a0	2025-12-19 06:47:14.695973	2025-12-19 06:47:14.695973
1368	53663b7f-7e1a-4b5f-9acc-02c5545694f7	2025-12-19 06:56:13.800121	2025-12-19 06:56:13.800121
1371	dd278fd6-cada-43e7-bd0a-cd4daaeaaaa5	2025-12-19 07:08:21.300935	2025-12-19 07:08:21.300935
1374	7f8cd44a-09c2-40e3-8c11-82af9b271b7e	2025-12-19 07:13:12.735357	2025-12-19 07:13:12.735357
1409	73eb049b-e4cb-44a8-9c82-5da172e2d52e	2025-12-19 09:33:00.12581	2025-12-19 09:33:00.12581
1410	545df63e-2c39-4047-9701-300ea5aa3c53	2025-12-19 09:37:18.795987	2025-12-19 09:37:18.795987
1411	8e9fff5c-6dc8-4987-8fe1-d559bcc5551d	2025-12-19 09:39:34.266308	2025-12-19 09:39:34.266308
1412	d1593bd0-aec1-41e1-81d0-68b25a1eeb07	2025-12-19 09:41:34.751151	2025-12-19 09:41:34.751151
1413	91120e01-7a21-4fdb-8b60-c8fc9d9d1fde	2025-12-19 09:41:47.262581	2025-12-19 09:41:47.262581
1414	0a52544c-d8f7-402e-9e89-e77633aeda32	2025-12-19 09:42:14.46093	2025-12-19 09:42:14.46093
1415	25b88488-3e45-422a-be06-5de838fc58b2	2025-12-19 09:43:06.042971	2025-12-19 09:43:06.042971
1416	dd10bd8a-89b6-46df-b2d1-4cc78658254e	2025-12-19 09:47:48.88863	2025-12-19 09:47:48.88863
1417	04500d87-87d9-4f43-b83e-127da8b26e6d	2025-12-19 09:49:34.812683	2025-12-19 09:49:34.812683
1418	6245f3d9-bfe6-4ac0-a54b-f8c281dfabe7	2025-12-19 09:53:20.181269	2025-12-19 09:53:20.181269
1419	fd053a70-1600-4ae3-b785-76c9b0e121ac	2025-12-19 09:56:00.616624	2025-12-19 09:56:00.616624
1420	7bf97b8e-25be-41f1-8236-9caabae596df	2025-12-19 10:00:00.199952	2025-12-19 10:00:00.199952
1421	2e67c5d5-69cd-4503-8b3c-9dae83fa6e34	2025-12-19 10:00:02.615633	2025-12-19 10:00:02.615633
1422	d34152b2-047c-4b83-8f1e-2e678b6f06b9	2025-12-19 10:03:49.908094	2025-12-19 10:03:49.908094
1423	bbd3f50c-a4c4-4110-a638-bad0115a1dd3	2025-12-19 10:04:16.283563	2025-12-19 10:04:16.283563
1424	3c52eb20-72fd-4a6d-96ac-44e2e968af5d	2025-12-19 10:05:18.753438	2025-12-19 10:05:18.753438
1425	0630a7e3-7c3f-49c2-b80e-9b8d5bd8d030	2025-12-19 10:06:38.842304	2025-12-19 10:06:38.842304
1426	8007ee4e-04f6-455c-a045-c113e64bd9dd	2025-12-19 10:07:58.534591	2025-12-19 10:07:58.534591
1427	ae87ef69-05cd-4c58-9abc-2f72f022a29c	2025-12-19 10:08:14.437422	2025-12-19 10:08:14.437422
1428	812ce9fa-0cd3-465b-af98-4e2dc27e8221	2025-12-19 10:09:20.355368	2025-12-19 10:09:20.355368
1429	2c6e3048-0d50-41fb-a9c0-f02a624a587b	2025-12-19 10:19:53.026718	2025-12-19 10:19:53.026718
1430	9eb7b9ba-4528-4b65-949d-eac45e3741b3	2025-12-19 10:24:11.292681	2025-12-19 10:24:11.292681
1431	84e26243-f1cf-4cd8-a8cf-7a26a4d97058	2025-12-19 10:26:35.769369	2025-12-19 10:26:35.769369
1432	6b7c6461-5857-4061-a5c7-4c24433a21b0	2025-12-19 10:30:03.25327	2025-12-19 10:30:03.25327
1433	df49dd36-5917-45af-9821-b56e94eecb52	2025-12-19 10:30:30.632489	2025-12-19 10:30:30.632489
1434	c115932e-5c29-40db-a7ba-9a8fda131c85	2025-12-19 10:32:27.203625	2025-12-19 10:32:27.203625
1435	2c301e77-e24e-431c-b6c4-dcad1133b083	2025-12-19 10:32:33.981629	2025-12-19 10:32:33.981629
1436	93c5fac8-ba7b-4795-bed1-42f863c61434	2025-12-19 10:43:33.669679	2025-12-19 10:43:33.669679
1437	f62ca73e-b367-4ae1-84b5-35d6d59e0375	2025-12-19 10:44:58.265061	2025-12-19 10:44:58.265061
1438	60686524-11f0-48e3-85a2-65d68f8f5518	2025-12-19 10:47:09.704986	2025-12-19 10:47:09.704986
1439	8ee3fecc-e9b9-420e-a288-3e6b5fa50eee	2025-12-19 10:52:36.656455	2025-12-19 10:52:36.656455
1440	c7c41085-71a4-4d47-9749-b918191eb556	2025-12-19 11:10:08.196358	2025-12-19 11:10:08.196358
1441	a00f1b2d-9b5e-40af-9e5c-e68656f36c1d	2025-12-19 11:11:32.314769	2025-12-19 11:11:32.314769
1442	e2b38a9e-e657-4ad5-b67e-1c6bc3df3f4f	2025-12-19 11:12:50.618578	2025-12-19 11:12:50.618578
1443	18a482f1-24af-49da-ab59-76e95416b733	2025-12-19 11:16:44.866191	2025-12-19 11:16:44.866191
1444	30b7cce9-3b89-4f7e-a7ce-99e482e764e1	2025-12-19 11:35:49.633408	2025-12-19 11:35:49.633408
1445	4f2e8e62-9eaa-4b70-82e4-f7a0013b7a28	2025-12-19 11:39:07.767918	2025-12-19 11:39:07.767918
1446	35a2e1ee-7c59-4222-bd47-1b966da1f0e9	2025-12-19 11:43:32.081024	2025-12-19 11:43:32.081024
1447	86cc00e0-5536-4d05-b49f-7dcf5b08bb18	2025-12-19 11:49:31.188452	2025-12-19 11:49:31.188452
1448	77cb5cf5-9180-40ff-92c5-e3b7bc9fc89d	2025-12-19 11:52:29.84374	2025-12-19 11:52:29.84374
1449	efb304d0-8a9e-43bf-825f-9c45c29aee0d	2025-12-19 12:16:08.922637	2025-12-19 12:16:08.922637
1450	1a85befe-81d4-4a2d-8e13-86e5ee132304	2025-12-19 12:16:41.455021	2025-12-19 12:16:41.455021
1451	1c810c6a-083b-4b56-bf16-d21e02468d13	2025-12-19 12:17:23.292696	2025-12-19 12:17:23.292696
1452	f5afd941-3edc-4249-9464-849d40b6cec7	2025-12-19 12:17:41.958621	2025-12-19 12:17:41.958621
1453	2ec2a843-b36c-417b-8a86-3098820a9f87	2025-12-19 12:17:50.04318	2025-12-19 12:17:50.04318
1454	11a33459-74cb-4dcd-8841-4c48ba8643f5	2025-12-19 12:36:02.458005	2025-12-19 12:36:02.458005
1455	168ef768-d734-440c-b220-40a3a12dfe46	2025-12-19 12:45:38.20926	2025-12-19 12:45:38.20926
1456	c09dac32-bcbc-4ec2-9c2b-a4fa1330a89a	2025-12-19 12:48:52.023332	2025-12-19 12:48:52.023332
1457	fd48cd5c-99ff-4696-8e3d-7df3bdc84825	2025-12-19 12:58:29.68584	2025-12-19 12:58:29.68584
1458	74b95074-cdfb-447c-9742-49fd9a0b5152	2025-12-19 13:02:18.457397	2025-12-19 13:02:18.457397
1459	5be3df85-26ed-4c2c-b135-037a089a5364	2025-12-19 13:02:28.928516	2025-12-19 13:02:28.928516
1460	65589a03-aff5-47fa-89a2-5b6b00770bf2	2025-12-19 13:13:16.658045	2025-12-19 13:13:16.658045
1461	9b4930e7-89e3-48eb-81a8-717984ae1e15	2025-12-19 13:17:27.416409	2025-12-19 13:17:27.416409
1462	caeedf4b-5cf2-4170-b2ba-650b5a1a7ba9	2025-12-19 13:21:04.820866	2025-12-19 13:21:04.820866
1463	ef815758-73cb-48dd-90b6-8886f003f9ed	2025-12-19 13:30:31.189541	2025-12-19 13:30:31.189541
1464	cd1cc82b-152d-480a-8095-5d4bd2304258	2025-12-19 13:31:24.974478	2025-12-19 13:31:24.974478
1465	a50841d3-a7f8-4c6e-875a-7a763a17101e	2025-12-19 13:36:17.179913	2025-12-19 13:36:17.179913
1466	d428bdf1-3b2e-41d5-9167-352b9b6ae143	2025-12-19 13:41:05.596553	2025-12-19 13:41:05.596553
1467	21fdc683-c310-4be8-8f04-98a7336c29cf	2025-12-19 13:45:08.7653	2025-12-19 13:45:08.7653
1468	59a809e3-77e3-4775-8f53-e9b5aa374441	2025-12-19 14:14:15.867161	2025-12-19 14:14:15.867161
1469	506ffb94-bb65-49e0-b286-f2bb80931cfd	2025-12-19 14:18:05.000244	2025-12-19 14:18:05.000244
1470	a2604ad7-cc02-4229-a20a-01100861b2af	2025-12-19 14:19:27.243083	2025-12-19 14:19:27.243083
1471	4e424df5-26aa-42fd-baaa-191b9891863a	2025-12-19 14:19:48.779811	2025-12-19 14:19:48.779811
1472	4727d0d9-2916-40c6-8dae-29de41543b40	2025-12-19 14:26:20.09121	2025-12-19 14:26:20.09121
1473	915bbe3f-e28f-4352-a7e7-d1a98841e59a	2025-12-19 14:28:19.977895	2025-12-19 14:28:19.977895
1474	41735dde-99b8-4615-bf03-d731d06c61a4	2025-12-19 14:32:18.575072	2025-12-19 14:32:18.575072
1475	bdb3c72f-a5bf-408b-bada-e81b6c89ef7f	2025-12-19 14:34:43.08455	2025-12-19 14:34:43.08455
1476	bab450f1-a49b-4055-8f75-293434704080	2025-12-19 14:37:13.580824	2025-12-19 14:37:13.580824
1477	b493e921-21ff-4fe8-88b4-8a5bf1ecda1f	2025-12-19 14:47:42.406132	2025-12-19 14:47:42.406132
1478	69e15631-71f1-439b-91dc-b71ba5bf6831	2025-12-19 14:56:35.680344	2025-12-19 14:56:35.680344
1479	16cd4dcc-2caf-42b9-b5ad-57636fdbfb41	2025-12-19 15:04:16.044873	2025-12-19 15:04:16.044873
1480	86a1a37b-ba4f-42e0-b9f5-1acc74b45cd9	2025-12-19 15:06:49.851937	2025-12-19 15:06:49.851937
1481	2705bf69-b937-4237-9426-2d3436ed4e5a	2025-12-19 15:08:04.491715	2025-12-19 15:08:04.491715
1482	f9047bb7-1c0d-41fb-a448-e62e9225830a	2025-12-19 15:19:34.810711	2025-12-19 15:19:34.810711
1483	64b4cdb4-5b7d-49de-9eac-328726375882	2025-12-19 15:23:19.373222	2025-12-19 15:23:19.373222
1484	d0479548-a6a6-430d-9f30-227b177f909c	2025-12-19 15:40:27.919884	2025-12-19 15:40:27.919884
1485	95a2cd1c-8fb2-4e5b-80ce-76895ec98710	2025-12-19 15:40:38.861169	2025-12-19 15:40:38.861169
1486	0679d5c9-8f24-4035-9b2f-95394c9b9490	2025-12-19 15:44:02.504443	2025-12-19 15:44:02.504443
1487	7d23b0be-4b3f-4499-865b-ff35dcbf87f3	2025-12-19 15:46:29.185407	2025-12-19 15:46:29.185407
1488	1c37a306-ef65-4ee7-8556-4929b22dd24f	2025-12-19 15:56:35.772287	2025-12-19 15:56:35.772287
1489	30f71c91-b431-42fb-b07e-bacaf4d99428	2025-12-19 16:01:08.022733	2025-12-19 16:01:08.022733
1490	72cecbbb-9299-45fa-9e1e-b9821677c818	2025-12-19 16:01:11.240952	2025-12-19 16:01:11.240952
1491	843b4f79-4269-499d-8fe2-90c98f952db8	2025-12-19 16:06:49.275536	2025-12-19 16:06:49.275536
1492	c9bd2f62-c8cb-4f47-a78a-171f7705cbaf	2025-12-19 16:17:47.52072	2025-12-19 16:17:47.52072
1493	c33f3dc6-aae7-495e-a3a4-19b01360d441	2025-12-19 16:20:28.722827	2025-12-19 16:20:28.722827
1494	e98c4b59-787b-4ac0-9631-1be8d23dc4db	2025-12-19 16:23:25.116837	2025-12-19 16:23:25.116837
1495	511b0e0b-46a1-4f61-b801-a69a71c47392	2025-12-19 16:34:18.314817	2025-12-19 16:34:18.314817
1496	f19ce28a-ce08-4cb5-a76e-6a46a9846b8d	2025-12-19 16:34:51.765994	2025-12-19 16:34:51.765994
1497	91bdb28b-6eba-4c13-b388-34fa8e4cd3f2	2025-12-19 16:42:57.973275	2025-12-19 16:42:57.973275
1498	ae4d2284-ce5b-4afe-a432-1b60415c2271	2025-12-19 16:58:32.155721	2025-12-19 16:58:32.155721
1499	3f7831fd-1173-4947-8c09-fd7a0cacd29b	2025-12-19 16:59:41.283575	2025-12-19 16:59:41.283575
1500	bb182ab3-692c-4661-ab83-0ca51a955969	2025-12-19 16:59:48.908858	2025-12-19 16:59:48.908858
1501	455a81d4-8442-4e71-a792-9d4a05a29936	2025-12-19 17:00:01.017244	2025-12-19 17:00:01.017244
1502	edb57a46-c56c-4a74-b5bb-c51a462f246e	2025-12-19 17:00:19.200076	2025-12-19 17:00:19.200076
1503	5ce1c79c-1e2c-47be-80d6-f33c5875b67d	2025-12-19 17:13:31.871355	2025-12-19 17:13:31.871355
1504	ee44bbca-b6b5-450b-a653-311e81a3e552	2025-12-19 17:20:58.006291	2025-12-19 17:20:58.006291
1505	1ff31c72-2ce1-4495-947f-6521ffd21e4f	2025-12-19 17:37:13.495196	2025-12-19 17:37:13.495196
1506	42d88249-1a08-42d6-bdd2-b561a30bea83	2025-12-19 17:38:17.71046	2025-12-19 17:38:17.71046
1507	361ea4b2-1c14-4e48-beda-917a9e1b825c	2025-12-19 17:50:44.41026	2025-12-19 17:50:44.41026
1508	35096ef9-fb27-4c4c-9865-a177612ba8a6	2025-12-19 17:56:11.588236	2025-12-19 17:56:11.588236
1509	fea137af-99d7-4b58-aaff-c26592ac1ca6	2025-12-19 18:03:16.663461	2025-12-19 18:03:16.663461
1510	1849d8e6-8205-4082-951d-34fa46e74f55	2025-12-19 18:12:59.40469	2025-12-19 18:12:59.40469
1511	b6e94692-4f90-4fb0-a844-7e142e2d4c75	2025-12-19 18:17:30.902512	2025-12-19 18:17:30.902512
1512	0f89de4a-4081-4f54-97dc-6c84e676052b	2025-12-19 18:19:36.431688	2025-12-19 18:19:36.431688
1513	fb84592d-14a5-43d0-9e34-b3021526f105	2025-12-19 18:25:15.665523	2025-12-19 18:25:15.665523
1514	2a99c30b-4807-4b85-ba2d-91e76cea93b8	2025-12-19 18:49:47.802933	2025-12-19 18:49:47.802933
1515	eaddbb25-b4b9-48a8-bb3c-2afd61e2608d	2025-12-19 19:39:28.018101	2025-12-19 19:39:28.018101
1516	7651242c-aeb9-46b7-a6ac-468025a22229	2025-12-20 06:06:14.801581	2025-12-20 06:06:14.801581
1517	ad827feb-51e1-4f71-81f0-3435b3876798	2025-12-20 07:34:57.267897	2025-12-20 07:34:57.267897
1518	cb5ccd56-1031-446d-9c25-ff778c200b3d	2025-12-20 08:13:32.2732	2025-12-20 08:13:32.2732
1519	800fc135-be7d-4b36-b54b-e8da0a2e7f0d	2025-12-20 08:42:26.616512	2025-12-20 08:42:26.616512
1520	b06cfb9f-db16-46f6-967d-7d0d884bc8df	2025-12-20 08:57:44.336204	2025-12-20 08:57:44.336204
1521	96acc626-b5e5-4471-a814-5ee008c37163	2025-12-20 10:19:29.03601	2025-12-20 10:19:29.03601
1522	bc7f0e27-5afd-4084-8c5a-52cbfe5e3cfc	2025-12-20 16:19:35.237728	2025-12-20 16:19:35.237728
1523	0f90658e-5467-4247-86a4-04938008d216	2025-12-20 17:01:18.812709	2025-12-20 17:01:18.812709
1524	6c7a0579-881c-49e2-9cb9-5fd58f9e62d5	2025-12-20 17:05:06.975634	2025-12-20 17:05:06.975634
1525	560ab7c9-0b8e-403a-b5ed-a3fbff7cdc25	2025-12-20 21:10:24.213054	2025-12-20 21:10:24.213054
1526	f1ad493d-9326-4231-8295-83ad17cedbe8	2025-12-20 21:14:55.240901	2025-12-20 21:14:55.240901
1527	2f3af25c-4b18-42dd-a936-e09b304c9400	2025-12-20 21:15:38.567405	2025-12-20 21:15:38.567405
1528	fe10fe11-44f4-44e6-aa7c-610521388fa8	2025-12-20 21:20:37.86815	2025-12-20 21:20:37.86815
1529	7ba81d2f-6075-44e2-9250-7c17662573dd	2025-12-21 06:05:29.119006	2025-12-21 06:05:29.119006
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.categories (id, name, slug, description, parent_id, is_active, sort_order, created_at, updated_at) FROM stdin;
16	Raw	raw	\N	13	t	0	2025-08-16 06:54:34.773469	2025-08-16 06:54:34.773469
17	Powder	powder	\N	13	t	0	2025-08-16 06:54:41.839849	2025-08-16 06:54:41.839849
18	100% Organic	100-organic	\N	\N	t	0	2025-08-16 07:08:01.188561	2025-08-16 07:08:01.188561
14	Ground Coffees	ground-coffees	\N	12	t	0	2025-08-16 06:47:21.778479	2025-08-16 07:16:24.758
41	FILLTERED COFFEE POWDER	filltered-coffee-powder	\N	38	t	0	2025-08-16 08:35:41.753153	2025-08-16 08:35:41.753153
43	No preservatives	sub-no-preservatives	The product which is in your table is 100% preservatives free and brought directly to your home  	18	t	0	2025-08-20 01:59:58.941421	2025-08-20 01:59:58.941421
44	NICE POWDER	sub-nice-powder	A coffee beans is grinded till the nice powder form  to dilute in water or in milk (it can be added to milk directly and boil)	38	t	0	2025-08-20 12:08:58.564654	2025-08-20 12:08:58.564654
45	Raw coffee beans	cat-raw-coffee-beans	Here the raw coffee beans (parchment) directly packed from farm   	\N	t	0	2025-08-20 12:11:42.743692	2025-08-20 12:11:42.743692
46	Arabica parchment	sub-arabica-parchment	Arabica coffee beans here the raw coffee beans will be directly packed to your home 	45	t	0	2025-08-20 12:13:17.486593	2025-08-20 12:13:17.486593
54	NO PESTISIDES	sub-no-pestisides	here we connect the people who grow the product in home for themselves it will be little bit higher in prize  	18	t	0	2025-08-26 10:35:05.133446	2025-08-26 10:37:47.035
47	ROBASTA PARCEMENT	sub-robasta-parcement	ROBASTA coffee beans here the raw coffee beans will be directly packed to your home 	45	t	0	2025-08-20 12:13:57.523973	2025-08-20 12:14:56.713
13	BLACK PEPPER	cat-black-pepper	Spices used for the  cooking an ancient practice used in India 	\N	t	0	2025-08-16 06:47:10.879654	2025-08-21 03:10:02.036
51	MORINGA	cat-moringa	Moringa used for the ayurvedic  an ancient practice used in India 	\N	t	0	2025-08-21 03:15:54.739331	2025-08-21 03:15:54.739331
52	Moringa powder	sub-moringa-powder	here you get the dried and grinded powder in pack 	51	t	0	2025-08-21 04:09:06.531251	2025-08-21 04:09:06.531251
53	Moringa leaves	sub-moringa-leaves	here you get the Dried non grinded leaves 	51	t	0	2025-08-21 04:10:17.064091	2025-08-21 04:10:17.064091
38	COFFEE	cat-coffee	COFFEE 	\N	t	0	2025-08-16 08:34:33.841469	2025-09-03 04:49:15.026
61	Ginger	cat-ginger	Raw premium ginger 	\N	t	0	2025-09-04 05:38:48.105882	2025-09-04 05:39:08.874
62	ತೋಟದಾ ಶುಂಠಿ ( non preservatives )	sub-61-non-preservatives	which is grown naturally for home uses	61	t	0	2025-09-04 05:56:28.21359	2025-09-04 05:56:28.21359
\.


--
-- Data for Name: contact_messages; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.contact_messages (id, name, email, phone, subject, message, status, created_at, updated_at) FROM stdin;
2	Mountain Coffee Beans	admin@example.com	\N	WE LIKE THE PRODUCT CAN WE DEAL DIRECTLHY 	HI PLEASE CONTACT THIS NUMBER 	resolved	2025-08-16 16:23:58.037463	2025-08-28 10:44:35.029
3	Cassie	cassietianyi777@gamil.com	\N	Greetings from friends	Hello Abhinandan Gowda,\n\nI am Cassie. We've chatted on Alibaba and WhatsApp. Do you remember? You said you want to buy FPV drones and agricultural drones, so I gave you a quote. But you're too busy to read my message. Could you please reply to the message after you read this notice? As the year draws to a close, shipping costs will increase, and product prices will vary. You'll be paying a higher price for these products.\n\nLooking forward to your reply.🌹\n\nBest wishes,\n Cassie	unread	2025-10-28 02:36:25.421824	2025-10-28 02:36:25.421824
\.


--
-- Data for Name: discount_usage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.discount_usage (id, discount_id, user_id, order_id, session_id, used_at) FROM stdin;
\.


--
-- Data for Name: discounts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.discounts (id, code, type, value, description, min_purchase, usage_limit, per_user, used, start_date, end_date, status, applicable_products, applicable_categories, created_at, updated_at) FROM stdin;
12	WELCOME20	percentage	20	Welcome discount for new customers - 20% off first order	50	100	t	0	2025-05-01 00:00:00	2025-12-31 00:00:00	active	all	all	2025-12-10 10:53:09.066335	2025-12-10 10:53:09.066335
17	HARVEST10	percentage	10	Harvest season special - 10% off all products	0	0	f	0	2025-07-01 00:00:00	2025-09-30 00:00:00	scheduled	all	all	2025-12-10 10:53:09.066335	2025-12-10 10:53:09.066335
18	SPRING25	percentage	25	Spring festival discount - 25% off	100	75	t	0	2025-03-01 00:00:00	2025-04-30 00:00:00	expired	all	all	2025-12-10 10:53:09.066335	2025-12-10 10:53:09.066335
19	BIGORDER	fixed	100	Big order discount - ₹100 off on orders above ₹500	500	0	f	0	2025-06-01 00:00:00	2025-12-31 00:00:00	active	all	all	2025-12-10 10:53:09.066335	2025-12-10 10:53:09.066335
13	SUMMER15	percentage	15	Summer sale - 15% off on all products	0	0	f	0	2025-06-01 00:00:00	2025-08-31 00:00:00	disabled	all	all	2025-12-10 10:53:09.066335	2025-12-10 10:53:09.066335
15	COFFEELOV	percentage	25	Coffee lovers special - 25% off on coffee products	30	50	f	0	2025-06-01 00:00:00	2025-07-31 00:00:00	disabled	selected	Coffee & Tea	2025-12-10 10:53:09.066335	2025-12-10 10:53:09.066335
16	FLAT50	fixed	50	Flat ₹50 off on orders above ₹200	200	200	t	0	2025-06-01 00:00:00	2025-09-30 00:00:00	disabled	all	all	2025-12-10 10:53:09.066335	2025-12-10 10:53:09.066335
14	FREESHIP	shipping	100	Free shipping on orders above ₹75	75	0	f	0	2025-05-15 00:00:00	2025-12-15 00:00:00	disabled	all	all	2025-12-10 10:53:09.066335	2025-12-10 10:53:09.066335
\.


--
-- Data for Name: email_change_verifications; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.email_change_verifications (id, user_id, new_email, verification_token, verified, expires_at, created_at) FROM stdin;
\.


--
-- Data for Name: farmers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.farmers (id, name, email, phone, specialty, story, location, farm_name, certification_status, certification_details, farm_size, experience_years, website, social_media, bank_account, pan_number, aadhar_number, image_url, featured, verified, active, created_at, updated_at) FROM stdin;
5	NAGESH H S	vetrivilas88@gmail.com	9731195973	COFFEE ESTATE	For black pepper, the berries are harvested while they are still green and unripe. They are then briefly cooked in hot water, which helps to rupture the cell walls and prepare them for drying. Afterward, the berries are spread out to dry in the sun. During this process, they shrivel and turn a deep black, developing the pungent flavor we all know and love.	KODAGU KARNATAKA 	EVA ESTATES 	certified		5 ACERS	36						www,facebook.nages,in	f	t	t	2025-08-16 15:49:53.519335	2025-08-16 15:49:53.519335
4	darshan h s	abhishekchauhan3003@gmail.com	09650830901	pepper farms	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReAc3zKpOv3_ENJuVJoIuEvjUVa7IpXR_PHQ&s	kodugu karnataka 		none			\N						https://www.facebook.com/share/16oLPz8rCH/	f	f	t	2025-08-13 12:29:32.026928	2025-08-13 12:29:32.026928
\.


--
-- Data for Name: newsletter_subscriptions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.newsletter_subscriptions (id, name, email, agreed_to_terms, created_at) FROM stdin;
1	\N	test@example.com	t	2025-08-13 11:39:30.222926
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.order_items (id, order_id, product_id, quantity, price, variant_id) FROM stdin;
16	21	19	1	150	55
17	22	15	1	780	48
18	23	19	1	150	209
20	25	19	1	375	210
21	26	20	1	0	208
22	27	20	1	1200	206
23	28	20	1	230	207
24	29	20	2	0	208
25	30	20	1	1200	206
26	31	16	1	340	218
27	32	20	1	230	207
28	33	17	1	530	155
29	34	16	1	340	218
30	35	16	1	340	218
31	35	15	1	780	48
32	35	17	1	530	155
33	36	16	1	680	217
34	36	19	1	1500	212
35	36	18	1	150	213
36	36	20	1	0	208
37	37	20	1	0	208
38	38	19	1	750	211
39	39	20	1	0	208
40	40	16	1	340	218
41	40	20	1	0	208
42	41	20	1	0	208
43	42	15	1	780	48
44	42	17	1	530	155
45	43	20	1	0	208
46	44	15	1	780	48
47	45	15	1	390	228
48	46	24	1	390	232
49	47	15	1	198	229
50	48	19	1	150	209
51	49	24	1	215	233
52	50	17	1	530	155
53	51	25	1	167	234
54	52	15	1	792	48
55	53	24	1	215	233
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.orders (id, user_id, session_id, payment_id, total, status, cancellation_approved_by, cancellation_request_reason, payment_method, discount_id, cancellation_reason, delivered_at, created_at, updated_at, customer_info, tracking_id, status_timeline, cancellation_requested_at, cancellation_approved_at, cancellation_rejected_at, cancellation_rejection_reason, total_weight, shipping_cost) FROM stdin;
21	5	d7b043bb-9193-4c33-ae5a-9640aea03adb	\N	154.99	cancelled	\N	\N	cod	\N	\N	\N	2025-08-16 12:01:24.584823	2025-08-16 15:40:21.294	{"zip": "560054", "city": "Bangalore", "email": "admin@example.com", "notes": "", "phone": "9880374460", "state": "Karnataka", "address": "Muthyala nagara", "lastName": "Supritha S", "firstName": "Supritha"}	ANW815	[{"date": "2025-08-16T12:01:24.480Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-08-16T15:40:21.294Z", "status": "cancelled", "message": "Order status updated to cancelled"}]	\N	\N	\N	\N	0	0
25	5	27da7a88-74fa-4636-99b7-67d4ede93018	\N	420	cancelled	\N	\N	cod	\N	\N	\N	2025-08-28 11:50:59.333197	2025-09-25 13:50:51.177	{"zip": "560064", "city": "Yelahanka", "email": "abhinandanhr35@gmail.com", "notes": "", "phone": "9606263270", "state": "Karnataka", "address": "# 64 jajji balaji enclave near sai iris apartment", "lastName": "R", "firstName": "Abhinandan"}	AKU724	[{"date": "2025-08-28T11:50:59.239Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-09-25T13:50:51.177Z", "status": "cancelled", "message": "Order status updated to cancelled"}]	\N	\N	\N	\N	0.00001	45
28	5	218ee3ba-4434-4ef0-8bff-3c7c06eb408d	\N	275	cancelled	\N	\N	cod	\N	\N	\N	2025-08-29 08:47:47.997038	2025-09-25 13:49:56.701	{"zip": "121001", "city": "Faridabad", "email": "abhishekchauhan3003@gmail.com", "notes": "", "phone": "09650830901", "state": "Haryana", "address": "DC-912 Dabua Colony", "lastName": "chauhan", "firstName": "Abhishek"}	PCO230	[{"date": "2025-08-29T08:47:47.215Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-09-25T13:49:56.701Z", "status": "cancelled", "message": "Order status updated to cancelled"}]	\N	\N	\N	\N	0.1	45
23	6	7a93d7f8-b1bb-4f20-9e9c-8df3bf5eed1c	\N	190	cancelled	\N	\N	cod	\N	\N	2025-08-21 06:55:36.034	2025-08-21 05:34:00.453549	2025-08-21 06:55:40.285	{"zip": "560085", "city": "Bangalore ", "email": "Thejaswininaidu2097@gmail.com", "notes": "", "phone": "7619225548", "state": "Karnataka ", "address": "No 136, Shivathmaja Nilaya, 2nd floor, 3rd cross, 7th main, Syndicate Bank colony, BSK 3RD STAGE, BANGALORE 85", "lastName": "C R", "firstName": "Thejaswini"}	URB249	[{"date": "2025-08-21T05:34:00.350Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-08-21T06:53:41.213Z", "status": "processing", "message": "Order status updated to processing"}, {"date": "2025-08-21T06:55:30.013Z", "status": "cancelled", "message": "Order status updated to cancelled"}, {"date": "2025-08-21T06:55:36.034Z", "status": "delivered", "message": "Order status updated to delivered", "location": "No 136, Shivathmaja Nilaya, 2nd floor, 3rd cross, 7th main, Syndicate Bank colony, BSK 3RD STAGE, BANGALORE 85"}, {"date": "2025-08-21T06:55:40.285Z", "status": "cancelled", "message": "Order status updated to cancelled"}]	\N	\N	\N	\N	0.00001	45
26	5	218ee3ba-4434-4ef0-8bff-3c7c06eb408d	\N	45	cancelled	\N	\N	cod	\N	\N	\N	2025-08-29 07:36:29.16328	2025-09-25 13:50:45.906	{"zip": "121001", "city": "Faridabad", "email": "abhishekchauhan3003@gmail.com", "notes": "", "phone": "9650830901", "state": "Haryana", "address": "DC-912 Dabua Colony", "lastName": "chauhan", "firstName": "Abhishek"}	JVE917	[{"date": "2025-08-29T07:36:28.399Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-09-25T13:50:45.906Z", "status": "cancelled", "message": "Order status updated to cancelled"}]	\N	\N	\N	\N	0.2	45
41	4	ed85c6ac-4d59-443a-a58c-a79eaa31b7b9	\N	45	cancelled	\N	\N	cod	\N	\N	\N	2025-08-29 13:03:06.745283	2025-09-25 13:47:54.838	{"zip": "573432", "city": "HASSAN", "email": "abhinandanhr35@gmail.com", "notes": "", "phone": "9606263270", "state": "Karnataka", "address": "Flat/Door/Block  No.  Village/Town  31", "lastName": "H R", "firstName": "Abhinandan"}	IOY847	[{"date": "2025-08-29T13:03:05.932Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-09-25T13:47:54.838Z", "status": "cancelled", "message": "Order status updated to cancelled"}]	\N	\N	\N	\N	0.2	45
43	3	25f19707-4173-4db1-af2e-2980dd091888	\N	45	cancelled	\N	\N	cod	\N	\N	\N	2025-08-29 14:21:13.853771	2025-09-25 13:47:41.935	{"zip": "573432", "city": "HASSAN", "email": "abhishekchauhan3003@gmail.com", "notes": "", "phone": "9650830901", "state": "Karnataka", "address": "Flat/Door/Block  No.  Village/Town  31", "lastName": "Chauhan", "firstName": "Abhishek"}	BO023SXXXXX	[{"date": "2025-08-29T14:21:13.758Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-09-25T13:47:41.935Z", "status": "cancelled", "message": "Order status updated to cancelled"}]	\N	\N	\N	\N	0.2	45
42	4	c632b7da-53b8-4a9e-8e5f-b6408b76177f	\N	1430	cancelled	\N	\N	cod	\N	\N	\N	2025-08-29 13:39:40.71208	2025-09-25 13:47:47.29	{"zip": "121001", "city": "Faridabad", "email": "abhinandanhr35@gmail.com", "notes": "", "phone": "9606263270", "state": "Haryana", "address": "DC-912 Dabua Colony", "lastName": "H R", "firstName": "Abhinandan"}	JET343	[{"date": "2025-08-29T13:39:40.611Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-09-13T16:07:32.644Z", "status": "shipped", "message": "Order status updated to shipped", "location": "Warehouse, Delhi"}, {"date": "2025-09-25T13:47:47.290Z", "status": "cancelled", "message": "Order status updated to cancelled"}]	\N	\N	\N	\N	2	120
27	5	218ee3ba-4434-4ef0-8bff-3c7c06eb408d	\N	1282	cancelled	\N	\N	cod	\N	\N	\N	2025-08-29 07:44:04.543182	2025-09-25 13:49:50.906	{"zip": "121001", "city": "Faridabad", "email": "abhishekchauhan3003@gmail.com", "notes": "", "phone": "09650830901", "state": "Haryana", "address": "DC-912 Dabua Colony", "lastName": "chauhan", "firstName": "Abhishek"}	UGN731	[{"date": "2025-08-29T07:44:03.752Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-09-25T13:49:50.905Z", "status": "cancelled", "message": "Order status updated to cancelled"}]	\N	\N	\N	\N	1	82
45	10	dd58cd84-751b-453e-9110-9bc0aa36178e	pay_RGMUlLEwEZD3G3	472	delivered	\N	\N	razorpay	\N	\N	2025-09-17 09:58:54.78	2025-09-11 16:33:51.539605	2025-09-17 09:58:54.78	{"zip": "560036", "city": "Bangalore ", "email": "Amulyamaya@gmail.com", "notes": "", "phone": "8861181103", "state": "Karnataka ", "address": "Isiri building, 5th cross, Vaikuntam layout", "lastName": "BM", "firstName": "Amulya"}	CX002876268IN	[{"date": "2025-09-11T16:33:51.365Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-09-12T03:33:55.617Z", "status": "processing", "message": "Order status updated to processing"}, {"date": "2025-09-12T05:47:04.285Z", "status": "shipped", "message": "Order status updated to shipped", "location": "Warehouse, Delhi"}, {"date": "2025-09-17T09:58:54.780Z", "status": "delivered", "message": "Order status updated to delivered", "location": "Isiri building, 5th cross, Vaikuntam layout"}]	\N	\N	\N	\N	0.5	82
30	5	218ee3ba-4434-4ef0-8bff-3c7c06eb408d	\N	1282	cancelled	\N	\N	cod	\N	\N	\N	2025-08-29 09:34:01.572326	2025-09-25 13:49:18.507	{"zip": "121001", "city": "Faridabad", "email": "suraj@gmail.co", "notes": "", "phone": "0650830901", "state": "Haryana", "address": "DC-912 Dabua Colony", "lastName": "chauhan", "firstName": "suraj"}	GEZ668	[{"date": "2025-08-29T09:34:00.822Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-09-25T13:49:18.507Z", "status": "cancelled", "message": "Order status updated to cancelled"}]	\N	\N	\N	\N	1	82
31	5	218ee3ba-4434-4ef0-8bff-3c7c06eb408d	\N	422	cancelled	\N	\N	cod	\N	\N	\N	2025-08-29 09:39:48.823058	2025-09-25 13:49:10.92	{"zip": "121001", "city": "Faridabad", "email": "abhinandanhr35@gmail.com", "notes": "", "phone": "9606263270", "state": "Haryana", "address": "New town", "lastName": "H R", "firstName": "Abhinandan"}	UAR819	[{"date": "2025-08-29T09:39:48.051Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-09-25T13:49:10.920Z", "status": "cancelled", "message": "Order status updated to cancelled"}]	\N	\N	\N	\N	0.5	82
32	5	218ee3ba-4434-4ef0-8bff-3c7c06eb408d	\N	275	cancelled	\N	\N	cod	\N	\N	\N	2025-08-29 09:46:55.923009	2025-09-25 13:49:04.184	{"zip": "121001", "city": "Faridabad", "email": "abhinandanhr35@gmail.com", "notes": "", "phone": "9606263270", "state": "Haryana", "address": "delhi", "lastName": "H R", "firstName": "Abhinandan"}	GXJ493	[{"date": "2025-08-29T09:46:55.110Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-09-25T13:49:04.184Z", "status": "cancelled", "message": "Order status updated to cancelled"}]	\N	\N	\N	\N	0.1	45
33	5	218ee3ba-4434-4ef0-8bff-3c7c06eb408d	\N	612	cancelled	\N	\N	cod	\N	\N	\N	2025-08-29 09:51:56.068251	2025-09-25 13:48:56.759	{"zip": "121001", "city": "Faridabad", "email": "abhinandanhr35@gmail.com", "notes": "", "phone": "9606263270", "state": "Haryana", "address": "New town", "lastName": "H R", "firstName": "Abhinandan"}	SRZ978	[{"date": "2025-08-29T09:51:55.222Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-09-25T13:48:56.759Z", "status": "cancelled", "message": "Order status updated to cancelled"}]	\N	\N	\N	\N	1	82
34	5	218ee3ba-4434-4ef0-8bff-3c7c06eb408d	\N	422	cancelled	\N	\N	cod	\N	\N	\N	2025-08-29 10:01:12.202374	2025-09-25 13:48:49.437	{"zip": "121001", "city": "Faridabad", "email": "abhinandanhr35@gmail.com", "notes": "", "phone": "9606263270", "state": "Haryana", "address": "DC-912 Dabua Colony", "lastName": "H R", "firstName": "Abhinandan"}	WQA069	[{"date": "2025-08-29T10:01:11.425Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-09-25T13:48:49.437Z", "status": "cancelled", "message": "Order status updated to cancelled"}]	\N	\N	\N	\N	0.5	82
36	5	218ee3ba-4434-4ef0-8bff-3c7c06eb408d	\N	2430	cancelled	\N	\N	cod	\N	\N	\N	2025-08-29 10:19:18.637616	2025-09-25 13:48:38.522	{"zip": "121001", "city": "Faridabad", "email": "abhinandanhr35@gmail.com", "notes": "", "phone": "9606263270", "state": "Haryana", "address": "DC-912 Dabua Colony", "lastName": "H R", "firstName": "Abhinandan"}	RFC838	[{"date": "2025-08-29T10:19:17.818Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-09-25T13:48:38.522Z", "status": "cancelled", "message": "Order status updated to cancelled"}]	\N	\N	\N	\N	1.21025	100
37	5	218ee3ba-4434-4ef0-8bff-3c7c06eb408d	\N	45	cancelled	\N	\N	cod	\N	\N	\N	2025-08-29 12:48:54.550398	2025-09-25 13:48:33.43	{"zip": "573432", "city": "HASSAN", "email": "abhinandanhr35@gmail.com", "notes": "", "phone": "9606263270", "state": "Karnataka", "address": "Flat/Door/Block  No.  Village/Town  31", "lastName": "H R", "firstName": "Abhinandan"}	MHT130	[{"date": "2025-08-29T12:48:53.730Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-09-25T13:48:33.430Z", "status": "cancelled", "message": "Order status updated to cancelled"}]	\N	\N	\N	\N	0.2	45
38	5	218ee3ba-4434-4ef0-8bff-3c7c06eb408d	\N	795	cancelled	\N	\N	cod	\N	\N	\N	2025-08-29 12:55:27.181805	2025-09-25 13:48:29.474	{"zip": "573432", "city": "HASSAN", "email": "abhinandanhr35@gmail.com", "notes": "", "phone": "9606263270", "state": "Karnataka", "address": "Flat/Door/Block  No.  Village/Town  31", "lastName": "H R", "firstName": "Abhinandan"}	FNW740	[{"date": "2025-08-29T12:55:26.351Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-09-25T13:48:29.474Z", "status": "cancelled", "message": "Order status updated to cancelled"}]	\N	\N	\N	\N	0.00001	45
40	5	ebcd20da-4dca-4501-935b-e537516d3906	\N	422	cancelled	\N	\N	cod	\N	\N	\N	2025-08-29 13:02:03.48593	2025-09-25 13:48:02.055	{"zip": "121001", "city": "Faridabad", "email": "abhinandanhr35@gmail.com", "notes": "", "phone": "9606263270", "state": "Haryana", "address": "delhi", "lastName": "H R", "firstName": "Abhinandan"}	XZW463	[{"date": "2025-08-29T13:02:02.671Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-09-25T13:48:02.055Z", "status": "cancelled", "message": "Order status updated to cancelled"}]	\N	\N	\N	\N	0.7	82
44	9	45ddbe15-0f6d-45b5-a34c-3842c3c4ae4d	\N	862	cancelled	\N	\N	cod	\N	\N	\N	2025-08-30 18:49:58.462642	2025-09-25 13:47:34.834	{"zip": "570004", "city": "Mysore", "email": "keerthanrajrock@gmail.com", "notes": "", "phone": "7019294255", "state": "Karnataka ", "address": "#416/1 T.H Road, Devamba Agrahara , K.R Mohalla", "lastName": "Raj ", "firstName": "Keerthan"}	NEWXX	[{"date": "2025-08-30T18:49:58.364Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-09-01T02:39:02.375Z", "status": "cancelled", "message": "Order status updated to cancelled"}, {"date": "2025-09-03T11:50:10.481Z", "status": "processing", "message": "Order status updated to processing"}, {"date": "2025-09-25T13:47:34.834Z", "status": "cancelled", "message": "Order status updated to cancelled"}]	\N	\N	\N	\N	1	82
39	5	218ee3ba-4434-4ef0-8bff-3c7c06eb408d	\N	45	cancelled	\N	\N	cod	\N	\N	2025-09-25 13:48:08.832	2025-08-29 12:56:35.222317	2025-09-25 13:48:14.724	{"zip": "121001", "city": "Faridabad", "email": "abhinandanhr35@gmail.com", "notes": "", "phone": "9606263270", "state": "Haryana", "address": "DC-912 Dabua Colony", "lastName": "H R", "firstName": "Abhinandan"}	IRR371	[{"date": "2025-08-29T12:56:34.410Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-09-25T13:48:08.832Z", "status": "delivered", "message": "Order status updated to delivered", "location": "DC-912 Dabua Colony"}, {"date": "2025-09-25T13:48:14.724Z", "status": "cancelled", "message": "Order status updated to cancelled"}]	\N	\N	\N	\N	0.2	45
46	9	45ddbe15-0f6d-45b5-a34c-3842c3c4ae4d	\N	480	delivered	\N	\N	cod	\N	\N	2025-09-19 06:36:07.964	2025-09-12 03:48:58.375956	2025-09-19 06:36:07.964	{"zip": "570004", "city": "Mysore", "email": "keerthanrajrock@gmail.com", "notes": "", "phone": "7019294255", "state": "Karnataka ", "address": "#416/1 T.H Road, Devamba Agrahara , K.R Mohalla", "lastName": "Raj ", "firstName": "Keerthan"}	CX002912892IN	[{"date": "2025-09-12T03:48:58.261Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-09-12T05:45:53.851Z", "status": "shipped", "message": "Order status updated to shipped", "location": "Warehouse, Delhi"}, {"date": "2025-09-12T05:46:16.389Z", "status": "processing", "message": "Order status updated to processing"}, {"date": "2025-09-13T03:38:30.220Z", "status": "shipped", "message": "Order status updated to shipped", "location": "Warehouse, Delhi"}, {"date": "2025-09-19T06:36:07.964Z", "status": "delivered", "message": "Order status updated to delivered", "location": "#416/1 T.H Road, Devamba Agrahara , K.R Mohalla"}]	\N	\N	\N	\N	0.5	82
35	5	218ee3ba-4434-4ef0-8bff-3c7c06eb408d	\N	1852	cancelled	\N	\N	cod	\N	\N	\N	2025-08-29 10:11:16.408552	2025-09-25 13:48:43.835	{"zip": "121001", "city": "Faridabad", "email": "abhinandanhr35@gmail.com", "notes": "new msg for testing", "phone": "9606263270", "state": "Haryana", "address": "DC-912 Dabua Colony", "lastName": "H R", "firstName": "Abhinandan"}	RZW072	[{"date": "2025-08-29T10:11:15.630Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-09-25T13:48:43.835Z", "status": "cancelled", "message": "Order status updated to cancelled"}]	\N	\N	\N	\N	2.5	202
48	5	d7b043bb-9193-4c33-ae5a-9640aea03adb	\N	203	delivered	\N	\N	cod	\N	\N	2025-09-25 13:45:35.378	2025-09-20 12:02:34.666888	2025-09-25 13:45:35.378	{"zip": "560056", "city": "Bangalore", "email": "9880374460suprithamadhu@gmail.com", "notes": "", "phone": "9880374460", "state": "Karnataka", "address": "Muthyala nagara 2nd cross jp park near vismaya medical", "lastName": "Supritha ", "firstName": "Supritha"}	CX003399882IN	[{"date": "2025-09-20T12:02:34.513Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-09-20T16:05:38.145Z", "status": "processing", "message": "Order status updated to processing"}, {"date": "2025-09-23T05:43:35.291Z", "status": "shipped", "message": "Order status updated to shipped", "location": "Warehouse, Delhi"}, {"date": "2025-09-25T13:45:35.378Z", "status": "delivered", "message": "Order status updated to delivered", "location": "Muthyala nagara 2nd cross jp park near vismaya medical"}]	\N	\N	\N	\N	0.00001	45
29	5	218ee3ba-4434-4ef0-8bff-3c7c06eb408d	\N	45	cancelled	\N	\N	cod	\N	\N	\N	2025-08-29 09:30:08.922913	2025-09-25 13:49:23.721	{"zip": "121001", "city": "Faridabad", "email": "abhishekchauhan3003@gmail.com", "notes": "", "phone": "0650830901", "state": "Haryana", "address": "DC-912 Dabua Colony", "lastName": "chauhan", "firstName": "Abhishek"}	ORL752	[{"date": "2025-08-29T09:30:08.145Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-09-25T13:49:23.721Z", "status": "cancelled", "message": "Order status updated to cancelled"}]	\N	\N	\N	\N	0.4	45
47	5	d7b043bb-9193-4c33-ae5a-9640aea03adb	\N	251	delivered	\N	\N	cod	\N	\N	2025-09-25 13:45:40.436	2025-09-20 11:59:59.377203	2025-09-25 13:45:40.436	{"zip": "560056", "city": "Bangalore", "email": "9880374460suprithamadhu@gmail.com", "notes": "", "phone": "9880374460", "state": "Karnataka", "address": "Muthtala nagara 2nd cross jp park  near vismaya medical", "lastName": "Supritha ", "firstName": "supritha"}	CX003399882IN	[{"date": "2025-09-20T11:59:59.224Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-09-20T16:05:55.171Z", "status": "processing", "message": "Order status updated to processing"}, {"date": "2025-09-23T05:43:40.311Z", "status": "shipped", "message": "Order status updated to shipped", "location": "Warehouse, Delhi"}, {"date": "2025-09-25T13:45:40.436Z", "status": "delivered", "message": "Order status updated to delivered", "location": "Muthtala nagara 2nd cross jp park  near vismaya medical"}]	\N	\N	\N	\N	0.25	45
22	4	27da7a88-74fa-4636-99b7-67d4ede93018	\N	862	cancelled	\N	cxbdfbhtgfh	cod	\N	\N	2025-08-28 11:52:41.476	2025-08-21 05:03:17.809342	2025-09-25 13:49:40.797	{"zip": "560064", "city": "Yelahanka", "email": "abhinandanhr35@gmail.com", "notes": "", "phone": "9606263270", "state": "Karnataka", "address": "# 64 jajji balaji enclave near sai iris apartment", "lastName": "H R ", "firstName": "Abhinandan"}	KLK0123	[{"date": "2025-08-21T05:03:17.704Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-08-28T09:20:55.540Z", "status": "cancelled", "message": "Order status updated to cancelled"}, {"date": "2025-08-28T11:52:41.476Z", "status": "delivered", "message": "Order status updated to delivered", "location": "# 64 jajji balaji enclave near sai iris apartment"}, {"date": "2025-08-28T11:53:25.880Z", "status": "processing", "message": "Order status updated to processing"}, {"date": "2025-08-28T12:11:18.687Z", "status": "cancelled", "message": "Order status updated to cancelled"}, {"date": "2025-08-28T12:12:32.687Z", "status": "shipped", "message": "Order status updated to shipped", "location": "Warehouse, Delhi"}, {"date": "2025-08-28T12:13:19.470Z", "status": "processing", "message": "Order status updated to processing"}, {"date": "2025-08-28T12:13:37.379Z", "status": "pending", "message": "Order status updated to pending"}, {"date": "2025-08-28T12:14:12.428Z", "status": "cancellation_requested", "message": "Customer requested order cancellation: cxbdfbhtgfh"}, {"date": "2025-09-25T13:49:40.797Z", "status": "cancelled", "message": "Order status updated to cancelled"}]	2025-08-28 12:14:12.428	\N	\N	\N	1	82
50	14	2833550c-ef7e-45a2-b416-57717e28a90f	\N	638	delivered	\N	\N	cod	\N	\N	2025-10-24 08:07:11.755	2025-10-24 08:06:17.05732	2025-10-24 08:07:11.755	{"zip": "121001", "city": "faridabad", "email": "9650830901dev@gmail.com", "notes": "", "phone": "9650830901", "state": "haryana", "address": "dc-912", "lastName": "chauhan", "firstName": "Shubham"}	OAW757	[{"date": "2025-10-24T08:06:16.911Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-10-24T08:07:11.755Z", "status": "delivered", "message": "Order status updated to delivered", "location": "dc-912"}]	\N	\N	\N	\N	1	100
49	4	27da7a88-74fa-4636-99b7-67d4ede93018	\N	293	delivered	\N	\N	cod	\N	\N	2025-10-27 09:56:05.674	2025-10-11 03:26:01.733886	2025-10-27 09:56:05.674	{"zip": "573134", "city": "HASSAN", "email": "abhinandanhr35@gmail.com", "notes": "", "phone": "9606263270", "state": "Karnataka", "address": "ABHINANDAN NILAYA", "lastName": "H R", "firstName": "Abhinandan"}	EZH591fokop	[{"date": "2025-10-11T03:26:01.589Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-10-11T10:58:59.609Z", "status": "cancelled", "message": "Order status updated to cancelled"}, {"date": "2025-10-11T10:59:00.521Z", "status": "cancelled", "message": "Order status updated to cancelled"}, {"date": "2025-10-13T08:52:03.136Z", "status": "shipped", "message": "Order status updated to shipped", "location": "Warehouse, Delhi"}, {"date": "2025-10-13T08:55:17.508Z", "status": "processing", "message": "Order status updated to processing"}, {"date": "2025-10-27T09:56:05.674Z", "status": "delivered", "message": "Order status updated to delivered", "location": "ABHINANDAN NILAYA"}]	\N	\N	\N	\N	0.25	70
52	5	9e75e758-3d72-4a84-ba46-c5321d4deefa	\N	900	delivered	\N	\N	cod	\N	\N	2025-10-30 11:09:41.091	2025-10-30 11:09:06.563075	2025-10-30 11:09:41.091	{"zip": "121001", "city": "Faridabad", "email": "admin@example.com", "notes": "", "phone": "0000000000", "state": "Haryana", "address": "DC-912", "lastName": "User", "firstName": "Admin"}	BGV478	[{"date": "2025-10-30T11:09:06.440Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-10-30T11:09:41.091Z", "status": "delivered", "message": "Order status updated to delivered", "location": "DC-912"}]	\N	\N	\N	\N	1	100
51	5	e51e6a46-c83f-41fd-9e25-7ce1f2890573	\N	275	delivered	\N	\N	cod	\N	\N	2025-10-29 13:11:05.1	2025-10-29 13:10:03.117771	2025-10-29 13:11:05.1	{"zip": "121001", "city": "faridabad", "email": "admin@example.com", "notes": "", "phone": "0000000000", "state": "Haryana", "address": "dc-912", "lastName": "User", "firstName": "Admin"}	ZAE788	[{"date": "2025-10-29T13:10:01.705Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-10-29T13:11:05.100Z", "status": "delivered", "message": "Order status updated to delivered", "location": "dc-912"}]	\N	\N	\N	\N	1	100
53	5	9e75e758-3d72-4a84-ba46-c5321d4deefa	\N	293	delivered	\N	\N	cod	\N	\N	2025-10-31 03:50:08.22	2025-10-31 03:49:25.77117	2025-10-31 03:50:08.22	{"zip": "121001", "city": "Faridabad", "email": "admin@example.com", "notes": "", "phone": "0000000000", "state": "Haryana", "address": "DC-912", "lastName": "User", "firstName": "Admin"}	TZP526	[{"date": "2025-10-31T03:49:25.654Z", "status": "confirmed", "message": "Your order has been placed successfully"}, {"date": "2025-10-31T03:50:08.220Z", "status": "delivered", "message": "Order status updated to delivered", "location": "DC-912"}]	\N	\N	\N	\N	0.25	70
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payments (id, user_id, order_id, razorpay_payment_id, amount, currency, status, method, created_at) FROM stdin;
3	10	45	pay_RGMUlLEwEZD3G3	472	INR	completed	\N	2025-09-11 16:33:53.283397
\.


--
-- Data for Name: product_reviews; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product_reviews (id, product_id, user_id, order_id, customer_name, rating, review_text, verified, created_at, variant_id) FROM stdin;
12	19	5	48	Admin User	3		f	2025-10-29 13:06:54.846931	209
13	19	5	48	Admin User	5	new products	f	2025-10-29 13:08:06.852767	209
14	25	5	51	Admin User	4	Good enought	f	2025-10-29 13:11:22.133939	234
15	25	5	51	Admin User	1	So, Fresh ginger	f	2025-10-30 11:07:11.640922	234
16	15	5	52	Admin User	3		f	2025-10-30 11:10:12.813067	48
17	24	5	53	Admin User	5	great product	f	2025-10-31 03:50:34.894699	233
\.


--
-- Data for Name: product_variants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product_variants (id, product_id, price, discount_price, quantity, unit, stock_quantity, sku, created_at, updated_at, is_deleted, weight) FROM stdin;
216	18	1890	1590	1	kg	100	SKU-BLPP-1KG	2025-08-21 04:53:03.259765	2025-11-12 12:14:57.758	f	0.04
221	22	850	779	1	kg	5	SKU-COFERP-1KG	2025-08-30 11:54:46.840951	2025-11-12 12:02:00.846	f	1
234	25	200	167	1	kg	4	SKU-GINGER-1KG	2025-09-04 05:53:29.969961	2025-11-12 12:03:31.43	f	1
236	25	100	100	0.5	kg	2	SKU-GINGER-500G	2025-09-27 06:55:53.409371	2025-11-12 12:03:31.636	f	0.5
220	21	600	575	2	kg	10	SKU-COFWP-1KG	2025-08-30 06:18:49.765706	2025-11-12 12:06:48.554	f	10
239	28	930	850	800	g	10	skurcofe01	2025-10-16 07:52:54.053553	2025-11-12 12:17:04.966	f	0.8
206	20	1300	1200	1	kg	0	SKU-MP-1KG	2025-08-21 04:40:46.876953	2025-11-12 12:10:42.87	f	1
207	20	250	250	100	g	3	SKU-MP-100G	2025-08-21 04:40:46.876953	2025-11-12 12:10:43.078	f	100
208	20	400	0	250	g	0	SKU-MP-1KG	2025-08-21 04:40:46.876953	2025-11-12 12:10:43.288	f	200
219	16	190	190	0.25	kg	10	SKU-MDC-250G	2025-08-21 05:01:41.7257	2025-11-12 12:12:01.531	f	0.25
217	16	760	690	1	kg	9	SKU-MIDC-2	2025-08-21 05:01:41.7257	2025-11-12 12:12:01.75	f	1
218	16	380	345	0.5	kg	6	SKU-MIDC-500G	2025-08-21 05:01:41.7257	2025-11-12 12:12:01.968	f	0.5
155	17	600	530	1	kg	9	SKU-COFFE-3	2025-08-20 13:09:16.941312	2025-11-12 12:13:18.877	f	1
226	17	0.023	270	0.5	kg	10	SKU-RBCF-500G	2025-08-30 13:01:32.145004	2025-11-12 12:13:19.081	f	0.5
227	17	170	170	0.25	kg	10	RBCF-250G	2025-08-30 13:01:32.145004	2025-11-12 12:13:19.286	f	0.25
209	19	180	180	100	g	6	SKU-SPR-100G	2025-08-21 04:52:16.793943	2025-11-12 12:14:33.394	f	0.01
210	19	450	375	250	g	9	SKU-SPR-250G	2025-08-21 04:52:16.793943	2025-11-12 12:14:33.598	f	0.01
212	19	1800	1500	1	kg	9	SKU-SPR-1KG	2025-08-21 04:52:16.793943	2025-11-12 12:14:33.802	f	0.01
211	19	900	750	500	g	9	SKU-SPR-500G	2025-08-21 04:52:16.793943	2025-11-12 12:14:34.006	f	0.01
213	18	189	189	100	g	99	SKU-BLPP-100G	2025-08-21 04:53:03.259765	2025-11-12 12:14:57.121	f	0.25
214	18	473	398	250	g	100	SKU-BLPP-250G	2025-08-21 04:53:03.259765	2025-11-12 12:14:57.334	f	0.03
215	18	945	795	500	g	100	SKU-BLPP-500G	2025-08-21 04:53:03.259765	2025-11-12 12:14:57.546	f	0.02
233	24	249.97	250	0.25	kg	8	SKU-COFFEFEP-250	2025-09-03 04:52:09.966438	2025-12-13 10:14:02.139	f	0.25
231	24	995	910	1	kg	10	SKU-COFFEFP-1000	2025-09-03 04:47:22.98493	2025-12-13 10:14:02.14	f	1
232	24	470	450	0.5	kg	9	SKU-COFFEFEP-500	2025-09-03 04:52:09.966438	2025-12-13 10:14:02.14	f	0.5
48	15	995	925	1	kg	8	SKU-COFFE-1	2025-08-16 06:51:10.193085	2025-12-13 10:16:19.283	f	1
228	15	475	450	0.5	kg	9	SKU-COFFE-500	2025-08-31 06:43:24.08745	2025-12-13 10:16:19.284	f	0.5
229	15	250	250	0.25	kg	9	SKU-COFFE-250	2025-08-31 06:43:24.08745	2025-12-13 10:16:19.285	f	0.25
240	29	1200	1050	1	kg	2	sku-coffe-rost1kg	2025-12-14 01:57:19.69188	2025-12-20 13:32:18.98	f	1
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.products (id, name, short_description, description, subcategory, category, image_url, image_urls, thumbnail_url, local_image_paths, video_url, farmer_id, featured, naturally_grown, chemical_free, premium_quality, meta_title, meta_description, slug, enable_share_buttons, enable_whatsapp_share, enable_facebook_share, enable_instagram_share, created_at, updated_at) FROM stdin;
18	Black Pepper	Black pepper here you get the premium  black pepper powder which is been grinded ( black pepper is collected from the farm )	Our black pepper powder is carefully processed to retain all the natural goodness of the peppercorns, ensuring a fresh, robust flavor that will elevate every dish in your kitchen. Beyond its exquisite taste, black pepper contains piperine, a potent antioxidant that supports digestion, boosts metabolism, and enhances nutrient absorption.	Powder	BLACK PEPPER	/uploads/products/ad7076fa-a10c-405f-a570-3c19840d4f11_generated-image (3).webp	{/uploads/products/bfb2052d-4f32-4923-b19c-a4d7dab75d88_generated-pepper.webp,/uploads/products/af10715d-f08c-4061-b46d-2ed55ace6139_blackpepper.webp,"/uploads/products/4850adc9-3b93-446d-bd65-d5e7b57305f2_black papper - Copy.webp"}	\N	{/uploads/products/bfb2052d-4f32-4923-b19c-a4d7dab75d88_generated-pepper.webp,/uploads/products/af10715d-f08c-4061-b46d-2ed55ace6139_blackpepper.webp,"/uploads/products/4850adc9-3b93-446d-bd65-d5e7b57305f2_black papper - Copy.webp"}	\N	5	f	t	t	t	\N	\N	\N	t	t	t	t	2025-08-16 06:58:37.416133	2025-11-12 12:14:56.483
22	Aribica coffee beans	Raw coffee beans  which is grown by farmers directly (non roosted)	coffee beans  "Experience the authentic taste of farm-direct coffee beans, responsibly grown and hand-picked by committed farmers. Each batch is traceable to the source, roasted for peak freshness, and offers distinctive flavors unique to the farm’s terroir. Direct purchasing supports fair wages, sustainable practices, and stronger farming communities—bringing top-quality beans straight from the field to the customer's cup."\n\nFarm-direct coffee is ideal for those who seek premium flavor, transparent sourcing, and a meaningful impact with every purchase.	Arabica parchment	Raw coffee beans	/uploads/products/96d1f1b8-6823-4028-89b2-e878627ace6c_generated-image (1).webp	{/uploads/products/f7fb5285-59fd-43d0-8c58-d5369f8de4b0_a58038e6-2600-47aa-a343-6724ffdf6a5e.webp,/uploads/products/8c9a44f2-e59e-47c8-a616-d77cd9aa2d3f_5b59e691-0645-4d52-9da0-c492526c6cc9.webp}	\N	{/uploads/products/f7fb5285-59fd-43d0-8c58-d5369f8de4b0_a58038e6-2600-47aa-a343-6724ffdf6a5e.webp,/uploads/products/8c9a44f2-e59e-47c8-a616-d77cd9aa2d3f_5b59e691-0645-4d52-9da0-c492526c6cc9.webp}	\N	4	t	t	t	t	\N	\N	\N	t	t	t	t	2025-08-30 11:54:46.840951	2025-11-12 12:02:00.193
20	MORINGA	Moringa oleifera, commonly known as the drumstick tree or miracle tree, is a plant with highly nutritious leaves that are dried and ground into a fine powder.	Moringa oleifera, commonly known as the drumstick tree or miracle tree, is a plant with highly nutritious leaves that are dried and ground into a fine powder. This powder has gained global recognition as a superfood due to its dense nutritional profile and potential health benefits.	Moringa powder	MORINGA	/uploads/products/620b6994-ada4-48c5-a038-5404bd77ce41_download (9).webp	{"/uploads/products/c9872485-0739-48d4-ac0f-1b8d68265997_download (10).webp","/uploads/products/13528352-4a64-4c33-9020-054802f90edc_download (9).webp","/uploads/products/2d940fc3-1c5e-4f31-9e9b-d21ea44d6ce1_download (11).webp"}	\N	{"/uploads/products/c9872485-0739-48d4-ac0f-1b8d68265997_download (10).webp","/uploads/products/13528352-4a64-4c33-9020-054802f90edc_download (9).webp","/uploads/products/2d940fc3-1c5e-4f31-9e9b-d21ea44d6ce1_download (11).webp"}	\N	5	t	t	t	t	\N	\N	\N	t	t	t	t	2025-08-16 07:10:57.385623	2025-11-12 12:10:42.246
16	Coffee Powder Arabica + Robusta Mix	Blending Arabica and Robusta beans is a common practice in the coffee industry, aiming to combine the desirable qualities of each for a more complex and balanced coffee experience.	Arabica beans are known for their sweet, smooth, and delicate flavors with notes of fruit, sugar, and berries, according to Sleepy Owl Coffee. Robusta beans, on the other hand, offer a stronger, bolder flavor with earthy, woody, nutty, and sometimes bitter notes.	FILLTERED COFFEE POWDER	Coffee	/uploads/products/8847ef16-ebd9-4bf5-8654-3ff87116e06d_download (6).webp	{/uploads/products/0a53cffe-5f91-4a50-8d9d-34318927122e_e4c17c61-cc61-4e10-82ae-5c3f2af31908.webp,"/uploads/products/a53a472e-ec8d-4de5-acf1-9c2b14508e05_download (6).webp"}	\N	{/uploads/products/0a53cffe-5f91-4a50-8d9d-34318927122e_e4c17c61-cc61-4e10-82ae-5c3f2af31908.webp,"/uploads/products/a53a472e-ec8d-4de5-acf1-9c2b14508e05_download (6).webp"}	\N	5	t	f	t	t	\N	\N	\N	t	t	t	t	2025-08-16 06:52:37.381686	2025-11-12 12:12:00.864
17	100% COFFEE Robasta mix	Robusta coffee, scientifically known as Coffea canephora, is a distinct species of coffee	Robusta coffee, scientifically known as Coffea canephora, is a distinct species of coffee bean known for its bold flavor profile and high caffeine content. While often overshadowed by Arabica in the specialty coffee world, 100% Robusta coffee powder is experiencing a resurgence in popularity.	NICE POWDER	Coffee	/uploads/products/a060671f-dc94-4223-9eb2-f04bf5029166_download (7).webp	{"/uploads/products/bc404f43-2a06-4ce4-852a-33492dbea7f8_download (5).webp","/uploads/products/e2627729-f6dd-41f2-9fb2-79a521470ca0_instacoffe - Copy.webp","/uploads/products/543763e2-bf61-4a97-9140-fcb17832419e_download (1).webp"}	\N	{"/uploads/products/bc404f43-2a06-4ce4-852a-33492dbea7f8_download (5).webp","/uploads/products/e2627729-f6dd-41f2-9fb2-79a521470ca0_instacoffe - Copy.webp","/uploads/products/543763e2-bf61-4a97-9140-fcb17832419e_download (1).webp"}	\N	5	t	t	t	f	\N	\N	\N	t	t	t	t	2025-08-16 06:53:54.540346	2025-11-12 12:13:18.261
15	Premium Coffee 100% Arabica Mix	100% Arabica mixes generally denote high-quality coffee blends made exclusively with Arabica beans	Premium Coffee 100% Arabica mixes generally denote high-quality coffee blends made exclusively with Arabica beans, known for their smoother, more nuanced flavor profile compared to Robusta.	NICE POWDER	Coffee	/uploads/products/1968f560-3c52-407f-94f2-ebea2051a0ee_download (7).webp	{"/uploads/products/182b4cd9-7264-4b6d-a897-0af372613192_download (1).webp","/uploads/products/5e0dfff7-24be-4035-91d0-2c46088a48c4_download (5).webp"}	\N	{"/uploads/products/182b4cd9-7264-4b6d-a897-0af372613192_download (1).webp","/uploads/products/5e0dfff7-24be-4035-91d0-2c46088a48c4_download (5).webp"}	\N	5	t	t	t	t	\N	\N	\N	t	t	t	t	2025-08-16 06:51:10.193085	2025-12-13 10:16:19.281
25	premium  ginger 	Here you get the premium ginger which is grown on estates 	Experience the finest quality premium ginger, carefully sourced and selected for its exceptional freshness (ತೋಟದಾ ಶುಂಠಿ)	ತೋಟದಾ ಶುಂಠಿ ( non preservatives )	Ginger	/uploads/products/e0b4760f-e6a7-4754-8d2f-84110ea41170_ginger.webp	{"/uploads/products/81d33edc-4944-415f-96b5-64659441f757_generated-image (29).webp"}	\N	{"/uploads/products/81d33edc-4944-415f-96b5-64659441f757_generated-image (29).webp"}	\N	4	t	t	t	t	\N	\N	\N	t	t	t	t	2025-09-04 05:53:29.969961	2025-11-12 12:03:30.806
21	ROBASTA COFFEE BEANS	Raw coffee beans  which is grown by farmers directly non roosted 	coffee beans  "Experience the authentic taste of farm-direct coffee beans, responsibly grown and hand-picked by committed farmers. Each batch is traceable to the source, roasted for peak freshness, and offers distinctive flavors unique to the farm’s terroir. Direct purchasing supports fair wages, sustainable practices, and stronger farming communities—bringing top-quality beans straight from the field to the customer's cup."\n\nFarm-direct coffee is ideal for those who seek premium flavor, transparent sourcing, and a meaningful impact with every purchase.	ROBASTA PARCEMENT	Raw coffee beans	/uploads/products/2ad5daa9-a2ef-4824-bdce-aa7750d28f6f_a58038e6-2600-47aa-a343-6724ffdf6a5e.webp	{/uploads/products/9ffbc412-00d1-475e-810b-bf53b5757b90_5b59e691-0645-4d52-9da0-c492526c6cc9.webp,/uploads/products/7ee10677-0d53-4bcb-9f72-82da2f256c82_instacoffe.webp,/uploads/products/b8bccb55-7bb6-4b5a-acf5-8bf81fa41ec9_a58038e6-2600-47aa-a343-6724ffdf6a5e.webp}	\N	{/uploads/products/9ffbc412-00d1-475e-810b-bf53b5757b90_5b59e691-0645-4d52-9da0-c492526c6cc9.webp,/uploads/products/7ee10677-0d53-4bcb-9f72-82da2f256c82_instacoffe.webp,/uploads/products/b8bccb55-7bb6-4b5a-acf5-8bf81fa41ec9_a58038e6-2600-47aa-a343-6724ffdf6a5e.webp}	\N	5	f	t	t	t	\N	\N	\N	t	t	t	t	2025-08-30 06:18:49.765706	2025-11-12 12:06:47.936
19	Black Pepper	Raw black pepper which is grown by farmers directly 	The King of Spices: A Journey into the World of Black Pepper\nFarm Fresh & Organic: Grown using sustainable methods without chemical fertilizers or pesticides, ensuring the product is pure and safe.\n\nHand-Harvested & Sun-Dried: Pepper is harvested at optimum ripeness and dried under natural sunlight, retaining essential oils and flavor.\n\nSuperior Aroma & Taste: Characterized by strong, pungent taste, vibrant fragrance, and a slight spicy kick, ideal for all cuisines.\n\nDirect from Farmers: Sourced directly after harvest, guaranteeing freshness, authentic taste, and enabling fair returns for farmers.\n\nNo Preservatives or Additives: Delivered unpolished and raw, the pepper maintains its natural nutrients and potenc\n\nHealth Benefits:\nBenefits of black pepper \nAid in nutrient absorption.\n\nPossess antioxidant and anti-inflammatory properties.\n\nPromote healthy digestion.	Raw	BLACK PEPPER	/uploads/products/49174a35-9889-44b0-aaa9-61df30ab37f1_black papper.webp	{/uploads/products/92465cb4-5879-498d-bb79-1ddbc509041c_blackpepper.webp,"/uploads/products/51f62e0b-1954-4d80-860c-2150310db416_black papper - Copy.webp"}	\N	{/uploads/products/92465cb4-5879-498d-bb79-1ddbc509041c_blackpepper.webp,"/uploads/products/51f62e0b-1954-4d80-860c-2150310db416_black papper - Copy.webp"}	\N	5	t	t	t	t	\N	\N	\N	t	t	t	t	2025-08-16 07:07:05.489945	2025-11-12 12:14:32.779
28	Aribica coffee beans	Raw coffee beans  which is grown by farmers directly ( roosted) 200 gm of chicory powder 	coffee beans  "Experience the authentic taste of farm-direct coffee beans, responsibly grown and hand-picked by committed farmers. Each batch is traceable to the source, roasted for peak freshness, and offers distinctive flavors unique to the farm’s terroir. Direct purchasing supports fair wages, sustainable practices, and stronger farming communities—bringing top-quality beans straight from the field to the customer's cup."\n\nFarm-direct coffee is ideal for those who seek premium flavor, transparent sourcing, and a meaningful impact with every purchase.	Arabica parchment	Raw coffee beans	/uploads/products/67c5e060-4a0d-402c-a99e-1126f43517d5_download (8).webp	{"/uploads/products/1a765c05-c78e-4573-ab5e-a1211249c8d8_download (2).webp","/uploads/products/9e7fe7de-10f3-4b20-b185-bd1781586509_download (3).webp","/uploads/products/51405e5e-c64d-4254-ad21-12170d4e14db_generated-image (77).webp"}	\N	{"/uploads/products/1a765c05-c78e-4573-ab5e-a1211249c8d8_download (2).webp","/uploads/products/9e7fe7de-10f3-4b20-b185-bd1781586509_download (3).webp","/uploads/products/51405e5e-c64d-4254-ad21-12170d4e14db_generated-image (77).webp"}	\N	4	t	f	t	t	\N	\N	\N	t	t	t	t	2025-10-16 07:52:54.053553	2025-11-12 12:17:04.316
24	Premium Coffee 100% Arabica Mix	H ere you get the coffee power in the filter form not a nice powder (cannot use  directly on milk )	Premium Coffee 100% Arabica mixes generally denote high-quality coffee blends made exclusively with Arabica beans, known for their smoother, more nuanced flavor profile compared to Robusta.	FILLTERED COFFEE POWDER	COFFEE	/uploads/products/6afd59ac-8295-4e6d-a319-77ee58f2d297_download (5).webp	{"/uploads/products/9ea02a57-ff46-473f-8372-f8c669361cd0_download (5).webp","/uploads/products/98efc08d-cb19-4bfb-9461-e1d84d0e8c67_download (6).webp","/uploads/products/da0ef49c-eb4e-4846-a0f7-3b4e17330d12_download (1).webp"}	\N	{"/uploads/products/9ea02a57-ff46-473f-8372-f8c669361cd0_download (5).webp","/uploads/products/98efc08d-cb19-4bfb-9461-e1d84d0e8c67_download (6).webp","/uploads/products/da0ef49c-eb4e-4846-a0f7-3b4e17330d12_download (1).webp"}	\N	4	t	t	t	t	\N	\N	\N	t	t	t	t	2025-09-03 04:47:22.98493	2025-12-13 10:14:02.13
29	Aribica coffee beans	Raw coffee beans  which is grown by farmers directly  roosted	coffee beans  "Experience the authentic taste of farm-direct coffee beans, responsibly grown and hand-picked by committed farmers. Each batch is traceable to the source, roasted for peak freshness, and offers distinctive flavors unique to the farm’s terroir. Direct purchasing supports fair wages, sustainable practices, and stronger farming communities—bringing top-quality beans straight from the field to the customer's cup."\n\nFarm-direct coffee is ideal for those who seek premium flavor, transparent sourcing, and a meaningful impact with every purchase.	Arabica parchment	Raw coffee beans	/uploads/products/68b29f6d-0e0f-4167-852a-1c68d3c3c095_generated-image (78).webp	{"/uploads/products/f96924e2-2e6d-4330-9409-34504520404f_download (3).webp","/uploads/products/398fdc98-0716-49c3-aff8-45cd234452cd_download (4).webp","/uploads/products/8613e454-2b9c-4db6-ab68-b52f19bec3e2_download (2).webp"}	\N	{"/uploads/products/f96924e2-2e6d-4330-9409-34504520404f_download (3).webp","/uploads/products/398fdc98-0716-49c3-aff8-45cd234452cd_download (4).webp","/uploads/products/8613e454-2b9c-4db6-ab68-b52f19bec3e2_download (2).webp"}	\N	5	t	t	t	t	\N	\N	\N	t	t	t	t	2025-12-14 01:57:19.69188	2025-12-20 13:32:18.972
\.


--
-- Data for Name: site_settings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.site_settings (id, key, value, type, description, updated_at) FROM stdin;
1	site_name	Freshly Rooted	text	Website name	2025-10-27 10:04:56.519
2	site_tagline	ನಮ್ಮ ರೈತರು ನಮ್ಮ ಹೆಮ್ಮೆ	text	Website tagline	2025-10-27 10:04:56.731
3	site_logo		text	Website logo URL	2025-10-27 10:04:56.938
4	store_email	freshlyrootedbusiness@gmail.com	text	Store contact email	2025-10-27 10:04:57.148
5	store_phone	+91 87624 67652	text	Store contact phone	2025-10-27 10:04:57.357
6	store_address	#SAKALESHPUR, CHIKAMAGALURU,MADKIERI	text	Store address	2025-10-27 10:04:57.566
7	store_city	HASSAN	text	Store city	2025-10-27 10:04:57.774
8	store_state	Karnataka	text	Store state	2025-10-27 10:04:57.986
9	store_zip	573134	text	Store zip code	2025-10-27 10:04:58.194
10	store_country	India	text	Store country	2025-10-27 10:04:58.403
11	social_facebook	https://www.facebook.com/profile.php?id=61578936222964&ref=_ig_profile_ac	text	Facebook page URL	2025-10-27 10:04:58.611
12	social_instagram	https://www.instagram.com/freshlyrootedbusiness?igsh=MWpsdzYzenNibm14eQ==	text	Instagram profile URL	2025-10-27 10:04:58.822
13	social_twitter	 https://freshlyrooted.in/api/upload/product-image	text	Twitter profile URL	2025-10-27 10:04:59.031
14	social_linkedin		text	LinkedIn company page URL	2025-10-27 10:04:59.24
15	social_youtube		text	YouTube channel URL	2025-10-27 10:04:59.449
16	social_website		text	Official website URL	2025-10-27 10:04:59.659
\.


--
-- Data for Name: sms_verifications; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sms_verifications (id, mobile, otp, purpose, verified, expires_at, created_at) FROM stdin;
1	9880374460	345978	registration	f	2025-08-16 10:46:24.875	2025-08-16 10:36:25.688887
2	9880374460	442110	registration	f	2025-08-16 10:46:34.301	2025-08-16 10:36:34.404008
3	9606263270	158171	registration	f	2025-08-17 04:26:30.071	2025-08-17 04:16:30.776961
4	9606263270	485609	registration	f	2025-08-17 04:26:39.199	2025-08-17 04:16:39.299308
5	9606263270	258677	registration	f	2025-08-18 06:33:43.228	2025-08-18 06:23:43.947898
6	9606263270	825628	registration	f	2025-08-19 08:42:27.308	2025-08-19 08:32:28.009429
7	9876543210	425744	registration	f	2025-08-19 09:29:59.284	2025-08-19 09:19:59.511797
9	9606263270	851441	registration	f	2025-08-19 09:52:06.688	2025-08-19 09:42:07.391313
11	9876543210	466368	registration	f	2025-08-19 09:57:21.952	2025-08-19 09:47:21.967449
12	9876543210	175422	registration	f	2025-08-19 09:58:10.671	2025-08-19 09:48:10.686824
13	9876543210	806886	registration	f	2025-08-19 09:58:42.74	2025-08-19 09:48:42.754853
14	9876543210	692586	registration	f	2025-08-19 09:59:46.056	2025-08-19 09:49:46.073381
15	9876543210	897158	registration	f	2025-08-19 10:00:12.977	2025-08-19 09:50:13.066309
18	9876543210	526443	registration	f	2025-08-19 10:19:33.693	2025-08-19 10:09:33.802762
19	9876543210	403396	registration	f	2025-08-19 10:19:54.45	2025-08-19 10:09:54.46618
22	9606263270	727518	registration	f	2025-08-19 10:53:24.734	2025-08-19 10:43:25.437317
23	9606263270	613575	registration	f	2025-08-19 11:50:46.899	2025-08-19 11:40:47.595744
33	9650830901	535213	registration	t	2025-08-19 14:16:19.861	2025-08-19 14:06:20.602357
34	9606263270	151538	registration	t	2025-08-19 14:21:28.091	2025-08-19 14:11:28.824542
35	9650830901	228344	registration	t	2025-08-19 17:26:29.808	2025-08-19 17:16:30.492449
36	7619225548	395009	registration	t	2025-08-21 05:34:00.537	2025-08-21 05:24:01.246961
37	7619225548	610793	registration	t	2025-08-21 05:34:47.594	2025-08-21 05:24:48.295157
41	9650830901	311459	registration	t	2025-08-29 07:51:11.579	2025-08-29 07:41:12.26652
42	7019294255	708044	registration	t	2025-08-30 18:56:52.153	2025-08-30 18:46:52.839973
43	8861181103	816776	registration	t	2025-09-02 09:14:33.96	2025-09-02 09:04:34.653618
44	7019294255	799038	registration	t	2025-09-02 09:40:38.163	2025-09-02 09:30:38.84583
45	8758058916	518116	registration	t	2025-09-29 12:20:54.183	2025-09-29 12:10:55.069497
46	9591805737	466487	registration	t	2025-10-14 05:08:58.568	2025-10-14 04:58:59.49416
47	9611959734	664395	registration	t	2025-10-17 15:02:18.45	2025-10-17 14:52:19.376234
48	9650830901	255150	registration	t	2025-10-24 08:14:36.525	2025-10-24 08:04:37.447223
\.


--
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.subscriptions (id, user_id, razorpay_subscription_id, plan_name, status, start_date, end_date, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: team_members; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.team_members (id, name, job_title, description, profile_image_url, display_order, is_active, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: testimonials; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.testimonials (id, name, title, content, rating, image_initials) FROM stdin;
1	Amit Sharma	Software Engineer	The service was excellent and the platform is very reliable.	4.7	AS
2	Priya Mehta	Marketing Manager	I found the dashboard very intuitive and easy to navigate.	4.9	PM
3	Rahul Verma	Entrepreneur	Great support team, they really helped me scale my business.	4.8	RV
4	Sneha Iyer	UI/UX Designer	The clean design and smooth experience made my work much easier.	5	SI
5	Vikram Singh	Project Manager	Overall, a very useful tool that improved our productivity.	4.6	VS
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, email, password, name, role, email_verified, verification_token, reset_token, reset_token_expiry, created_at, updated_at, mobile, mobile_verified, cod_enabled) FROM stdin;
5	admin@example.com	$2b$10$hvkzrOAfimB9M5aUNpU/uuji3HZqFp43nmygaYZBpa1o8fir60/OK	Admin User	admin	t	\N	\N	\N	2025-05-25 06:41:35.592	2025-08-16 11:56:46.385	0000000000	t	t
8	shubham@gmail.com	$2b$10$GPxJokEYs8pIdswHkGl30eUNvmwgAR8P4vnviw16vlv/Ekwy0GrVC	shubham	user	t	\N	\N	\N	2025-08-29 07:41:31.066233	2025-10-11 04:58:35.08	9650830901	t	t
12	ccl17manasabr@gmail.com	$2b$10$FGwhKToWDwPGDNmQ3uWjm.adhtumsZkuGhAEC7m7SbP4/o3.c7U66	Manasa	user	t	\N	\N	\N	2025-10-14 04:59:38.938124	2025-10-14 04:59:38.938124	9591805737	t	t
13	ashreeyahr34@gmail.com	$2b$10$tzbe1nFc0TePemcKWjoOI.3vgu12Vue/IWS0sk2u4apCYNriFRCje	Ashreeya H R	user	t	\N	\N	\N	2025-10-17 14:52:40.028795	2025-10-17 14:52:40.028795	9611959734	t	t
14	9650830901dev@gmail.com	$2b$10$5V33x8QVce3VNjYQ.BvPwOEA8FIo5XWUaiczZSP4WqLnoejuE38Uq	Shubham	user	t	\N	\N	\N	2025-10-24 08:04:53.854608	2025-10-24 08:04:53.854608	9650830901	t	t
6	Thejaswininaidu2097@gmail.com	$2b$10$Ne1SZvZdKZ0pXDmYwZt4cun8vXYZikArycXx6c1XmXoez4GYMcfrq	Thejaswini C R	user	t	\N	\N	\N	2025-08-21 05:25:34.25171	2025-08-21 05:25:34.25171	7619225548	t	t
4	abhinandanhr35@gmail.com	$2b$10$3sz1IRjpt4XWPnzd4JM.SOm5jdhkv9prATRJnLcoVYcVdHNXOWQwa	Abhinandan H R	user	t	\N	\N	\N	2025-08-19 14:11:52.182244	2025-08-19 14:11:52.182244	9606263270	t	t
10	Amulyamaya@gmail.com	$2b$10$k4BcXHEDEi.bT/vyOm6DtuizejJT7TX1oaZoz4wU8.VvpomrkwTNe	Amulya	user	t	\N	\N	\N	2025-09-02 09:04:56.882003	2025-09-02 09:04:56.882003	8861181103	t	t
9	keerthanrajrock@gmail.com	$2b$10$GDMVNoFdPxIgE.ZfnvpY4uC5R7JbYyFcK9FEW.bTyCV0Addd1.IpS	Keerthan Raj 	user	t	\N	ffd7b2bce5fc18928a513d09519d995b160addd3bfe41fed48269eb5358d1fd1	2025-09-02 10:29:57.949	2025-08-30 18:47:10.195164	2025-09-02 09:29:57.949	7019294255	t	t
11	deepakinfo997@gmail.com	$2b$10$EA2FHBwxuWnZpNNVYtUGXufpmr1gj5cu/BH2H7KaqO2vINuOXy5u6	Deepak Kumar Gupta	user	t	\N	\N	\N	2025-09-29 12:11:13.559253	2025-09-29 12:11:13.559253	8758058916	t	t
\.


--
-- Name: __drizzle_migrations_id_seq; Type: SEQUENCE SET; Schema: drizzle; Owner: -
--

SELECT pg_catalog.setval('drizzle.__drizzle_migrations_id_seq', 1, false);


--
-- Name: cart_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.cart_items_id_seq', 134, true);


--
-- Name: carts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.carts_id_seq', 1529, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categories_id_seq', 62, true);


--
-- Name: contact_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.contact_messages_id_seq', 3, true);


--
-- Name: discount_usage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.discount_usage_id_seq', 7, true);


--
-- Name: discounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.discounts_id_seq', 19, true);


--
-- Name: email_change_verifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.email_change_verifications_id_seq', 5, true);


--
-- Name: farmers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.farmers_id_seq', 5, true);


--
-- Name: newsletter_subscriptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.newsletter_subscriptions_id_seq', 2, true);


--
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.order_items_id_seq', 55, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.orders_id_seq', 53, true);


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.payments_id_seq', 3, true);


--
-- Name: product_reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.product_reviews_id_seq', 17, true);


--
-- Name: product_variants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.product_variants_id_seq', 240, true);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.products_id_seq', 29, true);


--
-- Name: site_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.site_settings_id_seq', 920, true);


--
-- Name: sms_verifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sms_verifications_id_seq', 48, true);


--
-- Name: subscriptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.subscriptions_id_seq', 1, false);


--
-- Name: team_members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.team_members_id_seq', 2, true);


--
-- Name: testimonials_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.testimonials_id_seq', 5, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 14, true);


--
-- Name: __drizzle_migrations __drizzle_migrations_pkey; Type: CONSTRAINT; Schema: drizzle; Owner: -
--

ALTER TABLE ONLY drizzle.__drizzle_migrations
    ADD CONSTRAINT __drizzle_migrations_pkey PRIMARY KEY (id);


--
-- Name: users_sync users_sync_pkey; Type: CONSTRAINT; Schema: neon_auth; Owner: -
--

ALTER TABLE ONLY neon_auth.users_sync
    ADD CONSTRAINT users_sync_pkey PRIMARY KEY (id);


--
-- Name: cart_items cart_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_pkey PRIMARY KEY (id);


--
-- Name: carts carts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: categories categories_slug_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_slug_unique UNIQUE (slug);


--
-- Name: contact_messages contact_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contact_messages
    ADD CONSTRAINT contact_messages_pkey PRIMARY KEY (id);


--
-- Name: discount_usage discount_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discount_usage
    ADD CONSTRAINT discount_usage_pkey PRIMARY KEY (id);


--
-- Name: discounts discounts_code_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discounts
    ADD CONSTRAINT discounts_code_unique UNIQUE (code);


--
-- Name: discounts discounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discounts
    ADD CONSTRAINT discounts_pkey PRIMARY KEY (id);


--
-- Name: email_change_verifications email_change_verifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_change_verifications
    ADD CONSTRAINT email_change_verifications_pkey PRIMARY KEY (id);


--
-- Name: email_change_verifications email_change_verifications_verification_token_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_change_verifications
    ADD CONSTRAINT email_change_verifications_verification_token_key UNIQUE (verification_token);


--
-- Name: farmers farmers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.farmers
    ADD CONSTRAINT farmers_pkey PRIMARY KEY (id);


--
-- Name: newsletter_subscriptions newsletter_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.newsletter_subscriptions
    ADD CONSTRAINT newsletter_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: product_reviews product_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_reviews
    ADD CONSTRAINT product_reviews_pkey PRIMARY KEY (id);


--
-- Name: product_variants product_variants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: site_settings site_settings_key_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.site_settings
    ADD CONSTRAINT site_settings_key_unique UNIQUE (key);


--
-- Name: site_settings site_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.site_settings
    ADD CONSTRAINT site_settings_pkey PRIMARY KEY (id);


--
-- Name: sms_verifications sms_verifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sms_verifications
    ADD CONSTRAINT sms_verifications_pkey PRIMARY KEY (id);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: team_members team_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_pkey PRIMARY KEY (id);


--
-- Name: testimonials testimonials_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.testimonials
    ADD CONSTRAINT testimonials_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users_sync_deleted_at_idx; Type: INDEX; Schema: neon_auth; Owner: -
--

CREATE INDEX users_sync_deleted_at_idx ON neon_auth.users_sync USING btree (deleted_at);


--
-- Name: discount_usage discount_usage_discount_id_discounts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discount_usage
    ADD CONSTRAINT discount_usage_discount_id_discounts_id_fk FOREIGN KEY (discount_id) REFERENCES public.discounts(id);


--
-- Name: discount_usage discount_usage_order_id_orders_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discount_usage
    ADD CONSTRAINT discount_usage_order_id_orders_id_fk FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: email_change_verifications email_change_verifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_change_verifications
    ADD CONSTRAINT email_change_verifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: order_items order_items_order_id_orders_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_orders_id_fk FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: order_items order_items_product_id_products_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_products_id_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: orders orders_discount_id_discounts_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_discount_id_discounts_id_fk FOREIGN KEY (discount_id) REFERENCES public.discounts(id);


--
-- Name: product_variants product_variants_product_id_products_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_variants
    ADD CONSTRAINT product_variants_product_id_products_id_fk FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: TABLE cart_items; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.cart_items TO myuser;


--
-- Name: SEQUENCE cart_items_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.cart_items_id_seq TO myuser;


--
-- Name: TABLE carts; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.carts TO myuser;


--
-- Name: SEQUENCE carts_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.carts_id_seq TO myuser;


--
-- Name: TABLE categories; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.categories TO myuser;


--
-- Name: SEQUENCE categories_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.categories_id_seq TO myuser;


--
-- Name: TABLE contact_messages; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.contact_messages TO myuser;


--
-- Name: SEQUENCE contact_messages_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.contact_messages_id_seq TO myuser;


--
-- Name: TABLE discount_usage; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.discount_usage TO myuser;


--
-- Name: SEQUENCE discount_usage_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.discount_usage_id_seq TO myuser;


--
-- Name: TABLE discounts; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.discounts TO myuser;


--
-- Name: SEQUENCE discounts_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.discounts_id_seq TO myuser;


--
-- Name: TABLE email_change_verifications; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.email_change_verifications TO myuser;


--
-- Name: SEQUENCE email_change_verifications_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.email_change_verifications_id_seq TO myuser;


--
-- Name: TABLE farmers; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.farmers TO myuser;


--
-- Name: SEQUENCE farmers_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.farmers_id_seq TO myuser;


--
-- Name: TABLE newsletter_subscriptions; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.newsletter_subscriptions TO myuser;


--
-- Name: SEQUENCE newsletter_subscriptions_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.newsletter_subscriptions_id_seq TO myuser;


--
-- Name: TABLE order_items; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.order_items TO myuser;


--
-- Name: SEQUENCE order_items_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.order_items_id_seq TO myuser;


--
-- Name: TABLE orders; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.orders TO myuser;


--
-- Name: SEQUENCE orders_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.orders_id_seq TO myuser;


--
-- Name: TABLE payments; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.payments TO myuser;


--
-- Name: SEQUENCE payments_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.payments_id_seq TO myuser;


--
-- Name: TABLE product_reviews; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.product_reviews TO myuser;


--
-- Name: SEQUENCE product_reviews_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.product_reviews_id_seq TO myuser;


--
-- Name: TABLE product_variants; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.product_variants TO myuser;


--
-- Name: SEQUENCE product_variants_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.product_variants_id_seq TO myuser;


--
-- Name: TABLE products; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.products TO myuser;


--
-- Name: SEQUENCE products_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.products_id_seq TO myuser;


--
-- Name: TABLE site_settings; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.site_settings TO myuser;


--
-- Name: SEQUENCE site_settings_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.site_settings_id_seq TO myuser;


--
-- Name: TABLE sms_verifications; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.sms_verifications TO myuser;


--
-- Name: SEQUENCE sms_verifications_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.sms_verifications_id_seq TO myuser;


--
-- Name: TABLE subscriptions; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.subscriptions TO myuser;


--
-- Name: SEQUENCE subscriptions_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.subscriptions_id_seq TO myuser;


--
-- Name: TABLE team_members; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.team_members TO myuser;


--
-- Name: SEQUENCE team_members_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.team_members_id_seq TO myuser;


--
-- Name: TABLE testimonials; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.testimonials TO myuser;


--
-- Name: SEQUENCE testimonials_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.testimonials_id_seq TO myuser;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.users TO myuser;


--
-- Name: SEQUENCE users_id_seq; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON SEQUENCE public.users_id_seq TO myuser;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO myuser;


--
-- PostgreSQL database dump complete
--

\unrestrict C2SmUSfThsqc2dqLP13XhzmHxNoj9hQDmKi96jRvwJdcKJscx8g8ynsBXIIdfN9

