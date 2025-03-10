BEGIN TRANSACTION;

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS "Bagasje" (
	"Registreringsnr"	INTEGER,
	"Billettreferanse"	TEXT NOT NULL,
	"Vekt"	INTEGER NOT NULL,
	"Innleveringstidspunkt"	DATETIME, -- Fjernet NOT NULL da denne ikke registreres før bagasjen er levert
	PRIMARY KEY("Registreringsnr" AUTOINCREMENT),
	FOREIGN KEY("Billettreferanse") REFERENCES "Billett"("Referansenr")
);

CREATE TABLE IF NOT EXISTS "BenytterFlytype" (
	"FlytypeID"	INTEGER NOT NULL,
	"FlyselskapID"	INTEGER NOT NULL,
	PRIMARY KEY("FlytypeID","FlyselskapID"),
	FOREIGN KEY("FlytypeID") REFERENCES "Flytype"("FlytypeID")
);

CREATE TABLE IF NOT EXISTS "Billett" (
	"Referansenr"	TEXT,
	"Kundenr"	INTEGER NOT NULL,
	"Løpenr"	INTEGER NOT NULL,
	"Prisklasse"	TEXT NOT NULL,
	"Pris"	INTEGER NOT NULL,
	"Setevalg"	TEXT,
	"ReiseFra"	TEXT NOT NULL,
	"ReiseTil"	TEXT NOT NULL,
	"Reisetype"	TEXT NOT NULL,
	PRIMARY KEY("REFERANSENR"),
	FOREIGN KEY("Kundenr") REFERENCES "Kunde"("Kundenr"),
	FOREIGN KEY("Løpenr") REFERENCES "Flyvning"("Løpenr")
);

CREATE TABLE IF NOT EXISTS "Delrute" (
	"DelruteID"	INTEGER,
	"FlyplasskodeAvgang"	TEXT NOT NULL,
	"FlyplasskodeAnkomst"	TEXT NOT NULL,
	"PlanlagtAvgang"	DATETIME NOT NULL,
	"PlanlagtAnkomst"	DATETIME NOT NULL,
	PRIMARY KEY("DelruteID"),
	FOREIGN KEY("FlyplasskodeAvgang") REFERENCES "Flyplass"("Flyplasskode"),
	FOREIGN KEY("FlyplasskodeAnkomst") REFERENCES "Flyplass"("Flyplasskode")
);

CREATE TABLE IF NOT EXISTS "Fly" (
	"Regnr"	INTEGER,
	"FlytypeID"	INTEGER NOT NULL,
	"Produsentnavn"	TEXT NOT NULL,
	"FlyselskapID"	INTEGER NOT NULL,
	"Serienr"	INTEGER NOT NULL,
	"Navn"	TEXT,
	"ÅrSattIDrift"	INTEGER NOT NULL,
	PRIMARY KEY("Regnr"),
	FOREIGN KEY("Produsentnavn") REFERENCES "Produsent"("Produsentnavn"),
	FOREIGN KEY("FlyselskapID") REFERENCES "Flyselskap"("FlyselskapID"),
	UNIQUE ("Serienr", "Produsentnavn")
);

CREATE TABLE IF NOT EXISTS "Flyplass" (
	"Flyplasskode"	TEXT,
	"Flyplassnavn"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("Flyplasskode")
);

CREATE TABLE IF NOT EXISTS "Flyrute" (
	"Flyrutenr"	INTEGER,
	"FlytypeID"	INTEGER NOT NULL,
	"FlyselskapID"	INTEGER NOT NULL,
	"Ukedagskode"	INTEGER NOT NULL,
	PRIMARY KEY("Flyrutenr"),
	FOREIGN KEY("FlytypeID") REFERENCES "Flytype"("FlytypeID")
);

CREATE TABLE IF NOT EXISTS "Flytype" (
	"FlytypeID"	INTEGER,
	"Produsentnavn"	TEXT NOT NULL,
	"Kabinkode"	INTEGER NOT NULL,
	"FlyselskapID"	INTEGER NOT NULL,
	"ProdusertFra"	INTEGER NOT NULL,
	"ProdusertTil"	INTEGER,
	PRIMARY KEY("FlytypeID"),
	FOREIGN KEY("Kabinkode") REFERENCES "Passasjerkabin"("Kabinkode")
);

CREATE TABLE IF NOT EXISTS "Flyvning" (
	"Løpenr"	TEXT,
	"Flyrutenr"	INTEGER NOT NULL,
    "Status" TEXT NOT NULL CHECK("Status" IN ('planned', 'active', 'completed', 'cancelled')),
	"FaktiskAvgang"	DATETIME,
	"FaktiskAnkomst"	DATETIME,
	PRIMARY KEY("Løpenr"),
	FOREIGN KEY("Flyrutenr") REFERENCES "Flyrute"("Flyrutenr")
);

CREATE TABLE IF NOT EXISTS "Fordelsprogram" (
	"ReferanseID"	INTEGER,
	"FlyselskapID"	INTEGER NOT NULL,
	"Kundenr"	INTEGER,
	"Nivå"	TEXT,
	PRIMARY KEY("ReferanseID"),
	FOREIGN KEY("Kundenr") REFERENCES "Kunde"("Kundenr"),
	FOREIGN KEY("FlyselskapID") REFERENCES "Flyselskap"("FlyselskapID")
);

CREATE TABLE IF NOT EXISTS "HarDelrute" (
	"DelruteID"	INTEGER NOT NULL,
	"Flyrutenr"	INTEGER NOT NULL,
	PRIMARY KEY("DelruteID","Flyrutenr"),
	FOREIGN KEY("DelruteID") REFERENCES "Delrute"("DelruteID"),
	FOREIGN KEY("Flyrutenr") REFERENCES "Flyrute"("Flyrutenr")
);

-- Med siste endringer behøves ikke denne tabellen
-- CREATE TABLE IF NOT EXISTS "HarRader" (
--	"Kabinkode"	INTEGER NOT NULL,
--	"Setekonfigurasjon"	TEXT NOT NULL,
--	"Radnummer"	TEXT NOT NULL,
--	PRIMARY KEY("Kabinkode","Setekonfigurasjon","Radnummer"),
--	FOREIGN KEY("Kabinkode") REFERENCES "Passasjerkabin"("Kabinkode")
--	FOREIGN KEY("Setekonfigurasjon") REFERENCES "Seterad"("Setekonfigurasjon")
--);

CREATE TABLE IF NOT EXISTS "Kunde" (
	"Kundenr"	INTEGER,
	"Navn"	TEXT NOT NULL,
	"Telefonnummer"	TEXT NOT NULL,
	"Epost"	TEXT NOT NULL,
	"Nasjonalitet"	TEXT NOT NULL,
	"Innsjekkingstidspunkt"	DATETIME,
	PRIMARY KEY("KUNDENR" AUTOINCREMENT)
);

CREATE TABLE IF NOT EXISTS "Passasjerkabin" (
	"Kabinkode"	INTEGER,
	PRIMARY KEY("Kabinkode")
);

CREATE TABLE IF NOT EXISTS "Produsent" (
	"Produsentnavn"	TEXT,
	"Nasjonalitet"	TEXT NOT NULL,
	"Stiftet" INTEGER NOT NULL,
	PRIMARY KEY("Produsentnavn")
);

CREATE TABLE IF NOT EXISTS "Seterad" (
    "Setekonfigurasjon" TEXT,
    "Radnr" INTEGER,
    "Kabinkode" INTEGER NOT NULL,
    "Merknad" TEXT,
    PRIMARY KEY("Setekonfigurasjon", "Radnr", "Kabinkode"),
    FOREIGN KEY("Kabinkode") REFERENCES "Passasjerkabin"("Kabinkode")
);

COMMIT;