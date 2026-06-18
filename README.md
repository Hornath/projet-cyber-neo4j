## 🛠️ Prérequis
Avant de commencer, assurez-vous d'avoir installé sur votre machine :
* **Git** (pour récupérer le projet)
* **Docker Desktop** (lancé et en cours d'exécution en arrière-plan)

---

## 🚀 Déploiement en 4 étapes

### Étape 1 : Récupérer le projet
Ouvrez un terminal (Invite de commandes ou PowerShell) et clonez ce dépôt sur votre machine :

```bash
git clone [https://github.com/Hornath/projet-cyber-neo4j.git](https://github.com/Hornath/projet-cyber-neo4j.git)
```

Déplacez-vous ensuite dans le dossier fraîchement téléchargé :

```bash
cd projet-cyber-neo4j
```

### Étape 2 : Lancer l'infrastructure Docker
Dans le même terminal, lancez le conteneur Neo4j en arrière-plan avec la commande suivante :

```bash
docker-compose up -d
```

> **Note technique :** Si un avertissement jaune indiquant que l'attribut `version` is obsolete s'affiche, ignorez-le. C'est un comportement normal des nouvelles versions de Docker. Attendez simplement de voir le message vert `Started`.

### Étape 3 : Se connecter à l'interface Neo4j
Ouvrez votre navigateur web et rendez-vous à l'adresse : [http://localhost:7474](http://localhost:7474)
*(Laissez à Neo4j une trentaine de secondes pour générer ses fichiers internes si la page est blanche au premier lancement).*

Sur la page de connexion, utilisez les identifiants suivants configurés dans notre fichier Docker :
* **Username :** `neo4j`
* **Password :** `password`

### Étape 4 : Injecter la cartographie du SI
Votre base de données est lancée mais elle est actuellement vide. Nous allons y injecter notre cartographie :

1. Ouvrez le fichier `scripts.cypher` (présent dans le dossier du projet) avec un éditeur de texte (Bloc-notes, VS Code...).
2. Copiez l'intégralité de son contenu.
3. Retournez sur votre navigateur (sur l'interface Neo4j), collez tout le code dans la longue barre de saisie en haut (`neo4j$`), puis cliquez sur le bouton bleu **Play** (ou faites `Ctrl + Entrée`).
4. Le moteur va créer instantanément les 31 nœuds (Utilisateurs, Machines, Vulnérabilités, Groupes, Ressources) et toutes leurs relations réseau.

---

## ✅ Vérification
Pour vous assurer que tout a parfaitement fonctionné, exécutez cette simple commande dans la barre de recherche Neo4j :

```cypher
MATCH (n) RETURN n;
```

Vous devriez voir apparaître l'intégralité du graphe de l'infrastructure CyberCorp sur votre écran. L'environnement est prêt !