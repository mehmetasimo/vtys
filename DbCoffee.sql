--
-- PostgreSQL database dump
--

-- Dumped from database version 13.4
-- Dumped by pg_dump version 13.1

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
-- Name: doneList(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."doneList"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	BEGIN
		IF NEW."CoffeeID" <> OLD."CoffeeID" THEN
			INSERT INTO "DoneCoffee"("CoffeeID", "Date")
			VALUES(OLD."CoffeeID", CURRENT_TIMESTAMP::TIMESTAMP);
		END IF;

		RETURN NEW;
	END;
	
$$;


ALTER FUNCTION public."doneList"() OWNER TO postgres;

--
-- Name: kahvegetir(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.kahvegetir(prmt integer) RETURNS TABLE(kahveadi character varying, hasatyili smallint, importer character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN Query
	SELECT 
	"CoffeeName",		-- coffee
	"HarvestingYear",		-- Country
	"Variety"			--RoastedCoffee
	FROM
	"Coffee"
	WHERE
	"HarvestingYear" > prmt;
	END;
	$$;


ALTER FUNCTION public.kahvegetir(prmt integer) OWNER TO postgres;

--
-- Name: kritikstok(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.kritikstok(kritik integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
	stok int;
	begin
		select count (*) into stok from "RoastedCoffee" where "Weight" <= kritik;
		return stok;
	end;
$$;


ALTER FUNCTION public.kritikstok(kritik integer) OWNER TO postgres;

--
-- Name: paperLog(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."paperLog"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF NEW."FilterPaper" <> OLD."FilterPaper" THEN
		INSERT INTO "PaperLog"("Method", "NewPaper", "OldPaper", "Date")
		VALUES(OLD."BrewMethod", NEW."FilterPaper", OLD."FilterPaper", CURRENT_TIMESTAMP::TIMESTAMP);
	END IF;

	RETURN NEW;
END;
$$;


ALTER FUNCTION public."paperLog"() OWNER TO postgres;

--
-- Name: station_log(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.station_log() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
if NEW."Station"<> OLD."Station" then
insert into "RegionLog" values(OLD."RegionID", OLD."Station", NEW."Station");
end if;
return NEW;
end;
$$;


ALTER FUNCTION public.station_log() OWNER TO postgres;

--
-- Name: stockChange(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."stockChange"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW."Weight" <> OLD."Weight" THEN
        INSERT INTO "StockLog"("RoastedID", "oldStock", "newStock", "Date")
        VALUES(OLD."RoastedID", OLD."Weight", NEW."Weight", CURRENT_TIMESTAMP::TIMESTAMP);
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public."stockChange"() OWNER TO postgres;

--
-- Name: tedarikciara(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.tedarikciara() RETURNS TABLE(importer character varying, variety character varying, process character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT "Importer", "Variety", "Process" FROM "Coffee";
END
$$;


ALTER FUNCTION public.tedarikciara() OWNER TO postgres;

--
-- Name: ulkekahve(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ulkekahve() RETURNS TABLE(kahveadi character varying, tedarikci character varying, islem character varying, ulke character varying)
    LANGUAGE plpgsql
    AS $$
Begin
Return Query
	Select "CoffeeName", "Importer", "Process", "Country" from "Coffee" join "Country" on "CountryID" = "CountryCode";
	end;
	$$;


ALTER FUNCTION public.ulkekahve() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Acidity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Acidity" (
    "AcidityID" integer NOT NULL,
    "Acidity" character varying(10)
);


ALTER TABLE public."Acidity" OWNER TO postgres;

--
-- Name: Acidity_AcidityID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Acidity_AcidityID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Acidity_AcidityID_seq" OWNER TO postgres;

--
-- Name: Acidity_AcidityID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Acidity_AcidityID_seq" OWNED BY public."Acidity"."AcidityID";


--
-- Name: Aroma; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Aroma" (
    "AromaID" integer NOT NULL,
    "Aroma" character varying(10)
);


ALTER TABLE public."Aroma" OWNER TO postgres;

--
-- Name: Aroma_AromaID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Aroma_AromaID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Aroma_AromaID_seq" OWNER TO postgres;

--
-- Name: Aroma_AromaID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Aroma_AromaID_seq" OWNED BY public."Aroma"."AromaID";


--
-- Name: Body; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Body" (
    "BodyID" integer NOT NULL,
    "Body" character varying(10)
);


ALTER TABLE public."Body" OWNER TO postgres;

--
-- Name: Body_BodyID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Body_BodyID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Body_BodyID_seq" OWNER TO postgres;

--
-- Name: Body_BodyID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Body_BodyID_seq" OWNED BY public."Body"."BodyID";


--
-- Name: BrewedCoffee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."BrewedCoffee" (
    "BrewID" integer NOT NULL,
    "BrewMethod" character varying(10) NOT NULL,
    "FilterPaper" character varying(10),
    "AcidityID" smallint,
    "BodyID" smallint,
    "AromaID" smallint
);


ALTER TABLE public."BrewedCoffee" OWNER TO postgres;

--
-- Name: BrewedCoffee_BrewID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."BrewedCoffee_BrewID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."BrewedCoffee_BrewID_seq" OWNER TO postgres;

--
-- Name: BrewedCoffee_BrewID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."BrewedCoffee_BrewID_seq" OWNED BY public."BrewedCoffee"."BrewID";


--
-- Name: Coffee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Coffee" (
    "CoffeeID" integer NOT NULL,
    "CoffeeName" character varying(20) NOT NULL,
    "HarvestingYear" smallint,
    "Importer" character varying(20) NOT NULL,
    "Price" double precision,
    "Variety" character varying(20),
    "Process" character varying(10),
    "CountryID" smallint NOT NULL,
    "BrewID" smallint,
    "RoastedID" smallint
);


ALTER TABLE public."Coffee" OWNER TO postgres;

--
-- Name: Coffee_CoffeeID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Coffee_CoffeeID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Coffee_CoffeeID_seq" OWNER TO postgres;

--
-- Name: Coffee_CoffeeID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Coffee_CoffeeID_seq" OWNED BY public."Coffee"."CoffeeID";


--
-- Name: Country; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Country" (
    "CountryCode" smallint NOT NULL,
    "Country" character varying(20) NOT NULL,
    "RegionID" smallint
);


ALTER TABLE public."Country" OWNER TO postgres;

--
-- Name: DoneCoffee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."DoneCoffee" (
    "CoffeeID" integer,
    "Date" date
);


ALTER TABLE public."DoneCoffee" OWNER TO postgres;

--
-- Name: Espresso; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Espresso" (
    "RoastedID" integer NOT NULL,
    "Profile" character varying(10)
);


ALTER TABLE public."Espresso" OWNER TO postgres;

--
-- Name: Farm; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Farm" (
    "FarmID" integer NOT NULL,
    "Farm" character varying(20),
    "Altitude" smallint,
    "ProducerID" smallint
);


ALTER TABLE public."Farm" OWNER TO postgres;

--
-- Name: Farm_FarmID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Farm_FarmID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Farm_FarmID_seq" OWNER TO postgres;

--
-- Name: Farm_FarmID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Farm_FarmID_seq" OWNED BY public."Farm"."FarmID";


--
-- Name: Filter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Filter" (
    "RoastedID" integer NOT NULL,
    "Profile" character varying(10)
);


ALTER TABLE public."Filter" OWNER TO postgres;

--
-- Name: Location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Location" (
    "LocationID" integer NOT NULL,
    "Location" character varying(15)
);


ALTER TABLE public."Location" OWNER TO postgres;

--
-- Name: Location_LocationID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Location_LocationID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Location_LocationID_seq" OWNER TO postgres;

--
-- Name: Location_LocationID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Location_LocationID_seq" OWNED BY public."Location"."LocationID";


--
-- Name: Omni; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Omni" (
    "RoastedID" integer NOT NULL,
    "Profile" character varying(10)
);


ALTER TABLE public."Omni" OWNER TO postgres;

--
-- Name: PaperLog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PaperLog" (
    "Method" character varying,
    "NewPaper" character varying,
    "OldPaper" character varying,
    "Date" date
);


ALTER TABLE public."PaperLog" OWNER TO postgres;

--
-- Name: Producer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Producer" (
    "ProducerID" integer NOT NULL,
    "Producer" character varying(20) NOT NULL
);


ALTER TABLE public."Producer" OWNER TO postgres;

--
-- Name: Producer_ProducerID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Producer_ProducerID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Producer_ProducerID_seq" OWNER TO postgres;

--
-- Name: Producer_ProducerID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Producer_ProducerID_seq" OWNED BY public."Producer"."ProducerID";


--
-- Name: Region; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Region" (
    "RegionID" integer NOT NULL,
    "Region" character varying(20) NOT NULL,
    "Station" character varying(20),
    "FarmID" smallint
);


ALTER TABLE public."Region" OWNER TO postgres;

--
-- Name: RegionLog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."RegionLog" (
    id integer,
    old_station character varying(20),
    new_station character varying(20)
);


ALTER TABLE public."RegionLog" OWNER TO postgres;

--
-- Name: TABLE "RegionLog"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."RegionLog" IS 'This table is added for tracking changes in regional stations.';


--
-- Name: Region_RegionID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Region_RegionID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Region_RegionID_seq" OWNER TO postgres;

--
-- Name: Region_RegionID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Region_RegionID_seq" OWNED BY public."Region"."RegionID";


--
-- Name: RoastedCoffee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."RoastedCoffee" (
    "RoastedID" integer NOT NULL,
    "Weight" integer NOT NULL,
    "RoasterID" smallint,
    "RoastProfile" character varying(8)
);


ALTER TABLE public."RoastedCoffee" OWNER TO postgres;

--
-- Name: RoastedCoffee_RoastedID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."RoastedCoffee_RoastedID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."RoastedCoffee_RoastedID_seq" OWNER TO postgres;

--
-- Name: RoastedCoffee_RoastedID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."RoastedCoffee_RoastedID_seq" OWNED BY public."RoastedCoffee"."RoastedID";


--
-- Name: Roaster; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Roaster" (
    "RoasterID" integer NOT NULL,
    "Roaster" character varying(20) NOT NULL,
    "Machine" character varying(20),
    "LocationID" smallint
);


ALTER TABLE public."Roaster" OWNER TO postgres;

--
-- Name: Roaster_RoasterID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Roaster_RoasterID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Roaster_RoasterID_seq" OWNER TO postgres;

--
-- Name: Roaster_RoasterID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Roaster_RoasterID_seq" OWNED BY public."Roaster"."RoasterID";


--
-- Name: StockLog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."StockLog" (
    "RoastedID" integer,
    "oldStock" integer,
    "newStock" integer,
    "Date" date
);


ALTER TABLE public."StockLog" OWNER TO postgres;

--
-- Name: Acidity AcidityID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Acidity" ALTER COLUMN "AcidityID" SET DEFAULT nextval('public."Acidity_AcidityID_seq"'::regclass);


--
-- Name: Aroma AromaID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Aroma" ALTER COLUMN "AromaID" SET DEFAULT nextval('public."Aroma_AromaID_seq"'::regclass);


--
-- Name: Body BodyID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Body" ALTER COLUMN "BodyID" SET DEFAULT nextval('public."Body_BodyID_seq"'::regclass);


--
-- Name: BrewedCoffee BrewID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BrewedCoffee" ALTER COLUMN "BrewID" SET DEFAULT nextval('public."BrewedCoffee_BrewID_seq"'::regclass);


--
-- Name: Coffee CoffeeID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Coffee" ALTER COLUMN "CoffeeID" SET DEFAULT nextval('public."Coffee_CoffeeID_seq"'::regclass);


--
-- Name: Farm FarmID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Farm" ALTER COLUMN "FarmID" SET DEFAULT nextval('public."Farm_FarmID_seq"'::regclass);


--
-- Name: Location LocationID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Location" ALTER COLUMN "LocationID" SET DEFAULT nextval('public."Location_LocationID_seq"'::regclass);


--
-- Name: Producer ProducerID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Producer" ALTER COLUMN "ProducerID" SET DEFAULT nextval('public."Producer_ProducerID_seq"'::regclass);


--
-- Name: Region RegionID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Region" ALTER COLUMN "RegionID" SET DEFAULT nextval('public."Region_RegionID_seq"'::regclass);


--
-- Name: RoastedCoffee RoastedID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RoastedCoffee" ALTER COLUMN "RoastedID" SET DEFAULT nextval('public."RoastedCoffee_RoastedID_seq"'::regclass);


--
-- Name: Roaster RoasterID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Roaster" ALTER COLUMN "RoasterID" SET DEFAULT nextval('public."Roaster_RoasterID_seq"'::regclass);


--
-- Data for Name: Acidity; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Acidity" VALUES
	(1, 'Malic'),
	(2, 'Citric'),
	(3, 'Tartaric'),
	(4, 'Sulphuric');


--
-- Data for Name: Aroma; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Aroma" VALUES
	(1, 'Pineapple'),
	(2, 'Chocolate'),
	(3, 'Orange'),
	(4, 'Almond');


--
-- Data for Name: Body; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Body" VALUES
	(1, 'Strong'),
	(2, 'Complex'),
	(3, 'Juicy'),
	(4, 'Weak');


--
-- Data for Name: BrewedCoffee; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."BrewedCoffee" VALUES
	(1, 'V60', 'Abaca', 1, 1, 1),
	(3, 'Clever', 'Hario', 3, 3, 3),
	(4, 'Aeropress', 'Delter', 4, 4, 4),
	(2, 'Kalita', 'TH2', 2, 2, 2);


--
-- Data for Name: Coffee; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Coffee" VALUES
	(1, 'Ameli', 2018, 'Circulor', 110, 'Bourbon', 'Dried', 2, 1, 3),
	(2, 'Ruby', 2021, 'Birlik', 100, 'Batian', 'Natural', 1, 1, 1),
	(3, 'Aponte', 2021, 'Tin', 130, 'Geisha', 'Natural', 1, 1, 1),
	(4, 'La Espranza', 2020, 'Sucafina', 90, 'Caturra', 'Washed', 2, 2, 2),
	(5, 'Aponte', 2021, 'CleanCup', 105, 'SL28', 'Natural', 3, 3, 3),
	(6, 'Aponte', 2019, 'Nordic', 130, 'Heirloom', 'Natural', 4, 4, 4);


--
-- Data for Name: Country; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Country" VALUES
	(1, 'Kenya', 1),
	(2, 'Brezilya', 2),
	(3, 'Kolombiya', 3),
	(4, 'Peru', 4);


--
-- Data for Name: DoneCoffee; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."DoneCoffee" VALUES
	(6, '2021-12-10'),
	(7, '2021-12-10');


--
-- Data for Name: Espresso; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: Farm; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Farm" VALUES
	(1, 'Kiangochi', 1600, 1),
	(2, 'Gerais', 750, 2),
	(3, 'El Tablon', 2150, 3),
	(4, 'Limatambo', 1713, 4);


--
-- Data for Name: Filter; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: Location; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Location" VALUES
	(1, 'İstanbul'),
	(2, 'İzmir'),
	(3, 'Ankara'),
	(4, 'Eskişehir');


--
-- Data for Name: Omni; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: PaperLog; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."PaperLog" VALUES
	('Kalita', 'TH2', 'TH3', '2021-12-10');


--
-- Data for Name: Producer; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Producer" VALUES
	(1, 'Kiyo Gikundu'),
	(2, 'Juiz de Fora'),
	(3, 'Roberto Payan'),
	(4, 'Martina Diaz');


--
-- Data for Name: Region; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Region" VALUES
	(1, 'Muranga', 'Macademia', 1),
	(2, 'Sul De Minas', 'Cooxupe', 2),
	(3, 'Narino', 'Aponte Community', 3),
	(4, 'Cajamarca', 'Kaluha', 4);


--
-- Data for Name: RegionLog; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."RegionLog" VALUES
	(4, 'Catimor', 'Kaluha');


--
-- Data for Name: RoastedCoffee; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."RoastedCoffee" VALUES
	(3, 340, 3, '3'),
	(4, 150, 4, '3'),
	(1, 150, 1, '1'),
	(2, 100, 2, '2');


--
-- Data for Name: Roaster; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Roaster" VALUES
	(1, 'Clean Cup', 'San Fran', 1),
	(2, 'Kafein Kultur', 'Wintop', 2),
	(3, 'Fam Coffee', 'Jetchil', 3),
	(4, 'Spada', 'Sprudge', 4);


--
-- Data for Name: StockLog; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."StockLog" VALUES
	(1, 250, 150, '2021-12-10'),
	(2, 250, 100, '2021-12-10');


--
-- Name: Acidity_AcidityID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Acidity_AcidityID_seq"', 1, false);


--
-- Name: Aroma_AromaID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Aroma_AromaID_seq"', 1, false);


--
-- Name: Body_BodyID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Body_BodyID_seq"', 1, false);


--
-- Name: BrewedCoffee_BrewID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."BrewedCoffee_BrewID_seq"', 1, false);


--
-- Name: Coffee_CoffeeID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Coffee_CoffeeID_seq"', 1, false);


--
-- Name: Farm_FarmID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Farm_FarmID_seq"', 1, false);


--
-- Name: Location_LocationID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Location_LocationID_seq"', 1, false);


--
-- Name: Producer_ProducerID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Producer_ProducerID_seq"', 1, false);


--
-- Name: Region_RegionID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Region_RegionID_seq"', 1, false);


--
-- Name: RoastedCoffee_RoastedID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."RoastedCoffee_RoastedID_seq"', 1, false);


--
-- Name: Roaster_RoasterID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Roaster_RoasterID_seq"', 1, false);


--
-- Name: Acidity Acidity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Acidity"
    ADD CONSTRAINT "Acidity_pkey" PRIMARY KEY ("AcidityID");


--
-- Name: Aroma Aroma_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Aroma"
    ADD CONSTRAINT "Aroma_pkey" PRIMARY KEY ("AromaID");


--
-- Name: Body Body_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Body"
    ADD CONSTRAINT "Body_pkey" PRIMARY KEY ("BodyID");


--
-- Name: BrewedCoffee BrewedCoffee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BrewedCoffee"
    ADD CONSTRAINT "BrewedCoffee_pkey" PRIMARY KEY ("BrewID");


--
-- Name: Coffee Coffee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Coffee"
    ADD CONSTRAINT "Coffee_pkey" PRIMARY KEY ("CoffeeID");


--
-- Name: Country CountryUnique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Country"
    ADD CONSTRAINT "CountryUnique" UNIQUE ("CountryCode");


--
-- Name: Country Country_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Country"
    ADD CONSTRAINT "Country_pkey" PRIMARY KEY ("CountryCode");


--
-- Name: Espresso EspressoPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Espresso"
    ADD CONSTRAINT "EspressoPK" PRIMARY KEY ("RoastedID");


--
-- Name: Farm Farm_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Farm"
    ADD CONSTRAINT "Farm_pkey" PRIMARY KEY ("FarmID");


--
-- Name: Filter FilterPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Filter"
    ADD CONSTRAINT "FilterPK" PRIMARY KEY ("RoastedID");


--
-- Name: Location Location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Location"
    ADD CONSTRAINT "Location_pkey" PRIMARY KEY ("LocationID");


--
-- Name: Omni OmniPK; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Omni"
    ADD CONSTRAINT "OmniPK" PRIMARY KEY ("RoastedID");


--
-- Name: Producer Producer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Producer"
    ADD CONSTRAINT "Producer_pkey" PRIMARY KEY ("ProducerID");


--
-- Name: Region Region_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Region"
    ADD CONSTRAINT "Region_pkey" PRIMARY KEY ("RegionID");


--
-- Name: RoastedCoffee RoastedCoffee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RoastedCoffee"
    ADD CONSTRAINT "RoastedCoffee_pkey" PRIMARY KEY ("RoastedID");


--
-- Name: Roaster RoasterUnique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Roaster"
    ADD CONSTRAINT "RoasterUnique" UNIQUE ("Roaster");


--
-- Name: Roaster Roaster_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Roaster"
    ADD CONSTRAINT "Roaster_pkey" PRIMARY KEY ("RoasterID");


--
-- Name: Coffee delCoffee; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "delCoffee" AFTER UPDATE ON public."Coffee" FOR EACH ROW EXECUTE FUNCTION public."doneList"();


--
-- Name: BrewedCoffee paperChange; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "paperChange" AFTER UPDATE ON public."BrewedCoffee" FOR EACH ROW EXECUTE FUNCTION public."paperLog"();


--
-- Name: Region station_change; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER station_change BEFORE UPDATE ON public."Region" FOR EACH ROW EXECUTE FUNCTION public.station_log();


--
-- Name: RoastedCoffee stockAlter; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "stockAlter" BEFORE UPDATE ON public."RoastedCoffee" FOR EACH ROW EXECUTE FUNCTION public."stockChange"();


--
-- PostgreSQL database dump complete
--

