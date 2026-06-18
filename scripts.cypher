
// Utilisateurs
CREATE (:User {name: "alice", role: "RH"}),
       (:User {name: "bob", role: "Développeur"}),
       (:User {name: "charlie", role: "Admin Système"}),
       (:User {name: "diana", role: "RSSI"}),
       (:User {name: "eve", role: "Stagiaire"});

// Machines
CREATE (:Machine {name: "PC-ALICE", type: "workstation", criticality: "low"}),
       (:Machine {name: "PC-BOB", type: "workstation", criticality: "medium"}),
       (:Machine {name: "SRV-WEB", type: "server", criticality: "medium"}),
       (:Machine {name: "SRV-DB", type: "database", criticality: "high"}),
       (:Machine {name: "DC-01", type: "domain_controller", criticality: "critical"}),
       (:Machine {name: "NAS-BACKUP", type: "backup_server", criticality: "critical"});

// Services
CREATE (:Service {name: "SSH", port: 22}),
       (:Service {name: "HTTP", port: 80}),
       (:Service {name: "HTTPS", port: 443}),
       (:Service {name: "RDP", port: 3389}),
       (:Service {name: "SMB", port: 445}),
       (:Service {name: "MongoDB", port: 27017});

// Vulnérabilités
CREATE (:Vulnerability {cve: "CVE-2021-44228", name: "Log4Shell", score: 10, description: "Exécution de code à distance via Log4j"}),
       (:Vulnerability {cve: "CVE-2020-1472", name: "Zerologon", score: 10, description: "Élévation de privilèges sur contrôleur de domaine"}),
       (:Vulnerability {cve: "CVE-2019-0708", name: "BlueKeep", score: 9.8, description: "Exécution de code à distance via RDP"}),
       (:Vulnerability {cve: "CVE-2022-22965", name: "Spring4Shell", score: 9.8, description: "Exécution de code à distance sur application Spring"}),
       (:Vulnerability {cve: "CVE-2023-0001", name: "SMB Misconfiguration", score: 7.5, description: "Mauvaise configuration du partage SMB"});

// Groupes
CREATE (:Group {name: "RH"}),
       (:Group {name: "DEV"}),
       (:Group {name: "ADMINS"}),
       (:Group {name: "SECURITY"});

// Ressources
CREATE (:Resource {name: "Base clients", sensitivity: "high"}),
       (:Resource {name: "Données RH", sensitivity: "high"}),
       (:Resource {name: "Active Directory", sensitivity: "critical"}),
       (:Resource {name: "Sauvegardes", sensitivity: "critical"}),
       (:Resource {name: "Secrets applicatifs", sensitivity: "critical"});









// Utilisateurs -> Machines et Groupes
MATCH (u:User {name: "alice"}), (m:Machine {name: "PC-ALICE"}), (g:Group {name: "RH"}) CREATE (u)-[:USES]->(m), (u)-[:MEMBER_OF]->(g);
MATCH (u:User {name: "bob"}), (m:Machine {name: "PC-BOB"}), (g:Group {name: "DEV"}) CREATE (u)-[:USES]->(m), (u)-[:MEMBER_OF]->(g);
MATCH (u:User {name: "charlie"}), (g:Group {name: "ADMINS"}) CREATE (u)-[:MEMBER_OF]->(g);
MATCH (u:User {name: "diana"}), (g:Group {name: "SECURITY"}) CREATE (u)-[:MEMBER_OF]->(g);

// Connexions Réseau
MATCH (a:Machine {name: "PC-ALICE"}), (b:Machine {name: "SRV-WEB"}) CREATE (a)-[:CONNECTED_TO]->(b);
MATCH (a:Machine {name: "PC-BOB"}), (b:Machine {name: "SRV-WEB"}) CREATE (a)-[:CONNECTED_TO]->(b);
MATCH (a:Machine {name: "SRV-WEB"}), (b:Machine {name: "SRV-DB"}) CREATE (a)-[:CONNECTED_TO]->(b);
MATCH (a:Machine {name: "SRV-DB"}), (b:Machine {name: "DC-01"}) CREATE (a)-[:CONNECTED_TO]->(b);
MATCH (a:Machine {name: "SRV-DB"}), (b:Machine {name: "NAS-BACKUP"}) CREATE (a)-[:CONNECTED_TO]->(b);

// Machines -> Services
MATCH (m:Machine {name: "SRV-WEB"}), (s1:Service {name: "HTTP"}), (s2:Service {name: "HTTPS"}) CREATE (m)-[:EXPOSES]->(s1), (m)-[:EXPOSES]->(s2);
MATCH (m:Machine {name: "SRV-DB"}), (s:Service {name: "MongoDB"}) CREATE (m)-[:EXPOSES]->(s);
MATCH (m:Machine {name: "DC-01"}), (s:Service {name: "SMB"}) CREATE (m)-[:EXPOSES]->(s);
MATCH (m:Machine {name: "PC-BOB"}), (s:Service {name: "RDP"}) CREATE (m)-[:EXPOSES]->(s);

// Machines -> Vulnérabilités
MATCH (m:Machine {name: "SRV-WEB"}), (v1:Vulnerability {cve: "CVE-2021-44228"}), (v2:Vulnerability {cve: "CVE-2022-22965"}) CREATE (m)-[:HAS_VULNERABILITY]->(v1), (m)-[:HAS_VULNERABILITY]->(v2);
MATCH (m:Machine {name: "PC-BOB"}), (v:Vulnerability {cve: "CVE-2019-0708"}) CREATE (m)-[:HAS_VULNERABILITY]->(v);
MATCH (m:Machine {name: "DC-01"}), (v:Vulnerability {cve: "CVE-2020-1472"}) CREATE (m)-[:HAS_VULNERABILITY]->(v);
MATCH (m:Machine {name: "NAS-BACKUP"}), (v:Vulnerability {cve: "CVE-2023-0001"}) CREATE (m)-[:HAS_VULNERABILITY]->(v);

// Groupes -> Accès Machines
MATCH (g:Group {name: "RH"}), (m:Machine {name: "SRV-WEB"}) CREATE (g)-[:HAS_ACCESS_TO]->(m);
MATCH (g:Group {name: "DEV"}), (m:Machine {name: "SRV-DB"}) CREATE (g)-[:HAS_ACCESS_TO]->(m);
MATCH (g:Group {name: "ADMINS"}), (m1:Machine {name: "DC-01"}), (m2:Machine {name: "NAS-BACKUP"}) CREATE (g)-[:HAS_ACCESS_TO]->(m1), (g)-[:HAS_ACCESS_TO]->(m2);

// Machines -> Ressources Hébergées
MATCH (m:Machine {name: "SRV-DB"}), (r1:Resource {name: "Base clients"}), (r2:Resource {name: "Secrets applicatifs"}) CREATE (m)-[:HOSTS]->(r1), (m)-[:HOSTS]->(r2);
MATCH (m:Machine {name: "DC-01"}), (r:Resource {name: "Active Directory"}) CREATE (m)-[:HOSTS]->(r);
MATCH (m:Machine {name: "NAS-BACKUP"}), (r:Resource {name: "Sauvegardes"}) CREATE (m)-[:HOSTS]->(r);