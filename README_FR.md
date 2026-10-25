![Lab4PurpleSec](/assets/images/icons/Lab4PurpleSec-icon-7-5.png)

# Lab4PurpleSec

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Status](https://img.shields.io/badge/status-active-success.svg)
![Platform](https://img.shields.io/badge/platform-VMware%20%7C%20VirtualBox%20%7C%20Hyper--V-lightgrey.svg)
![Maintenance](https://img.shields.io/badge/maintained-yes-green.svg)

> **Note** : Ce projet s'appelait précédemment "Lab4OffSec" et a été renommé en "Lab4PurpleSec" pour mieux refléter son orientation Purple Team.

> **Note** : Il s'agit d'une V1. Les retours et contributions sont les bienvenus.

> **📜 Mention de licence** : L'utilisation de ce projet (y compris pour des CTF, des projets commerciaux, de la formation ou tout autre usage) est soumise aux termes et conditions de la licence MIT. Voir `LICENSE` pour les détails complets. En utilisant ce projet, vous acceptez de respecter les termes de la licence, notamment la conservation des mentions de droits d'auteur et des informations de licence.

![🌍 English version available here](/README.md)

Lab4PurpleSec est un homelab de cybersécurité segmenté, conçu pour une pratique Red Team et Blue Team, combinant pentest réseau et web, attaques Active Directory et supervision défensive (SIEM, IDS/IPS). Il s'adresse aux étudiants et passionnés de cybersécurité qui préfèrent construire l'environnement « from scratch » plutôt que d'utiliser des VMs préconstruites. L'objectif est de comprendre chaque composant en l'installant et le configurant manuellement, de manière reproductible mais personnalisable.

## Scénarios

| Scénario | Statut | Lien |
| --- | --- | --- |
| Scénario 1 — Exploitation d'application web (WAN → DMZ) | documenté | [SCENARIOS/scenario-1-web-exploitation.md](SCENARIOS/scenario-1-web-exploitation.md) |
| Scénario 2 — Attaques Active Directory sur GOAD (Kerberoasting & AS-REP Roasting) | documenté | [SCENARIOS/scenario-2-active-directory.md](SCENARIOS/scenario-2-active-directory.md) |

> Voir aussi [SCENARIOS/00-lab-overview.md](SCENARIOS/00-lab-overview.md) pour la topologie du lab et l'index des scénarios.

![Homelab-light.png](/assets/images/Diagrams/Homelab-light.png)

## TL;DR

**Lab4PurpleSec** dispose des caractéristiques suivantes :

- Architecture segmentée (WAN, DMZ, LAN, AD)
- Firewall pfSense, IDS/IPS Suricata, SIEM Wazuh
- Machines vulnérables type OWASP, Metasploitable, DC Windows
- Guides détaillés d'installation et de configuration

Sommaire

- [Lab4PurpleSec](#lab4purplesec)
  - [Scénarios](#scénarios)
  - [TL;DR](#tldr)
  - [Présentation](#présentation)
  - [Prérequis](#prérequis)
    - [Configuration matérielle](#configuration-matérielle)
      - [Configuration minimale (scénarios limités)](#configuration-minimale-scénarios-limités)
      - [Configuration recommandée (expérience complète)](#configuration-recommandée-expérience-complète)
      - [Configuration optimale (performances maximales)](#configuration-optimale-performances-maximales)
    - [Configuration logicielle](#configuration-logicielle)
    - [Objectifs du projet](#objectifs-du-projet)
  - [Architecture réseau](#architecture-réseau)
    - [Lab4PurpleSec](#lab4purplesec-1)
    - [GOAD-MINILAB](#goad-minilab)
  - [Structure du projet](#structure-du-projet)
  - [Démarrage rapide](#démarrage-rapide)
    - [Option 1 : Déploiement automatisé (recommandé)](#option-1--déploiement-automatisé-recommandé)
    - [Option 2 : Déploiement manuel](#option-2--déploiement-manuel)
  - [Scénarios possibles](#scénarios-possibles)
    - [1. Pivoting : WAN → DMZ → LAN](#1-pivoting--wan--dmz--lan)
    - [2. Exploit Web OWASP → Persistance (webshell)](#2-exploit-web-owasp--persistance-webshell)
    - [3. Kerberoasting (AD) : reconnaissance \& récupération de tickets](#3-kerberoasting-ad--reconnaissance--récupération-de-tickets)
  - [Installation des composants](#installation-des-composants)
    - [Composants automatisés](#composants-automatisés)
    - [Composants manuels](#composants-manuels)
  - [Contributions](#contributions)
  - [Licence](#licence)
  - [Mentions légales](#mentions-légales)
  - [Credits](#credits)

## Présentation

Lab4PurpleSec est un homelab évolutif de cybersécurité conçu pour l'entraînement Red Team et Blue Team dans un contexte proche d'un environnement d'entreprise, intégrant pentest réseau/web, Active Directory, détection, SIEM et IDS/IPS.

Projet destiné aux étudiants et passionnés de cybersécurité !

## Prérequis

### Configuration matérielle

**Lab4PurpleSec** est conçu pour être flexible et peut être déployé selon vos besoins et les ressources disponibles. Vous n'avez pas besoin de lancer toutes les VMs simultanément : les scénarios sont conçus pour être exécutés étape par étape.

#### Configuration minimale (scénarios limités)

- **RAM :** 16 Go minimum
- **CPU :** processeur 4 cœurs (i5/i7 ou équivalent)
- **Stockage :** 150 Go d'espace disque libre
- **Cas d'usage :** Lancer 2-3 VMs à la fois pour des scénarios spécifiques (par ex. serveur web + machine d'attaque, ou SIEM + une cible)

#### Configuration recommandée (expérience complète)

- **RAM :** 32 Go recommandés
- **CPU :** processeur 6 cœurs ou plus (i5/i7/i9 ou équivalent)
- **Stockage :** 200+ Go d'espace disque libre (SSD recommandé)
- **Cas d'usage :** Lancer plusieurs VMs simultanément pour des scénarios complexes (par ex. environnement AD complet + SIEM + services web)

#### Configuration optimale (performances maximales)

- **RAM :** 64 Go
- **CPU :** processeur 8 cœurs ou plus (i9/Ryzen 9 ou équivalent)
- **Stockage :** 500+ Go d'espace disque libre (SSD NVMe recommandé)
- **Cas d'usage :** Lancer l'intégralité du lab simultanément avec tous les services actifs

> **Note** : Ces prérequis correspondent à une configuration de référence. Vous pouvez les adapter à vos besoins. Bien entendu, la RAM est **la ressource la plus importante** à considérer (pour la virtualisation, la puissance CPU/GPU est moins déterminante que la RAM).

**Notes importantes :**

- **Vous pouvez personnaliser les ressources des VMs** dans le `Vagrantfile` pour les adapter à votre matériel (réduire la RAM/CPU par VM si nécessaire)
- **Toutes les VMs n'ont pas besoin de tourner en même temps** : ne démarrez que les VMs nécessaires à votre scénario en cours
- **Le Wazuh Manager (LAN-SIEM-LIN) requiert 8 Go de RAM** : c'est la VM la plus gourmande en ressources
- **Les VMs GOAD (Windows)** nécessitent des ressources importantes : envisagez de les lancer séparément si la RAM est limitée
- **Utilisation de l'espace disque :** avec les paramètres par défaut, le lab utilise environ 130-150 Go

Pour les prérequis matériels et logiciels détaillés, voir `docs/SETUP/prereqs.md`.

### Configuration logicielle

- **Hyperviseur :** VirtualBox ou VMware Workstation/Player
- **Vagrant :** Version 2.2+ (pour les VMs automatisées)
- **Ansible :** Optionnel, pour l'exécution manuelle des playbooks
- **Images ISO :** Voir `docs/SETUP/prereqs.md` pour la liste complète

### Objectifs du projet

**Lab4PurpleSec** ne fournit pas de machines virtuelles préconstruites (OVA/OVF). L'installation se fait entièrement « from scratch » en suivant les guides détaillés fournis. Cette approche :

- **Encourage l'apprentissage** : Comprendre chaque étape d'installation et de configuration
- **Assure la reproductibilité** : Chaque utilisateur construit son environnement de manière identique (mais tout de même personnalisable)
- **Renforce la compréhension** : Maîtrise des systèmes, des réseaux et des configurations
- **Facilite la personnalisation** : Adaptation facile selon les besoins spécifiques

## Architecture réseau

### Lab4PurpleSec

Lab4PurpleSec est un environnement dédié à l'exploitation de vulnérabilités applicatives et systèmes, hébergeant des machines intentionnellement vulnérables (Metasploitable2/3), des applications web OWASP dans une zone DMZ isolée ainsi qu'un environnement Active Directory vulnérable (GOAD MINILAB). La topologie générale est présentée dans le diagramme en haut de ce document.

### GOAD-MINILAB

GOAD-MINILAB reproduit un environnement Active Directory simplifié avec un contrôleur de domaine et un poste client Windows (plusieurs si nécessaire), permettant de simuler divers types d'attaques orientées Active Directory.

![GOAD-MINILAB.png](/assets/images/Diagrams/GOAD-MINILAB.png)

## Structure du projet

Cette section présente l'organisation du dépôt **Lab4PurpleSec** et décrit le rôle de chaque répertoire et fichier principal. Cette structure permet une navigation claire entre les guides d'installation, les configurations, les tests et les ressources du projet.

```
Lab4PurpleSec/
├── README.md                      — Présentation générale et démarrage rapide (EN)
├── README_FR.md                   — Présentation générale et démarrage rapide (FR)
├── CONTRIBUTING.md                — Guide de contribution
├── LICENSE                        — Informations sur la licence et les droits d'utilisation
├── .gitignore                     — Fichiers/dossiers exclus du suivi Git
├── .github/
│   └── ISSUE_TEMPLATE/
│        ├── bug_report.md         — Modèle de rapport de bug
│        ├── feature_request.md    — Modèle de demande de fonctionnalité
│        └── documentation.md      — Modèle d'amélioration de la documentation
├── ARCHITECTURE.md                — Architecture, interfaces et diagrammes réseau
├── assets/                        — Ressources visuelles (images, diagrammes, etc.)
├── INVENTORY.md                   — Inventaire de toutes les VMs et de leurs caractéristiques principales
├── automation/                    — Automatisation Vagrant et Ansible des VMs internes
│   ├── README.md                  — Documentation et démarrage rapide de l'automatisation
│   ├── ORCHESTRATION.md           — Guide d'orchestration des VMs et d'intégration externe
│   ├── Vagrantfile                — Configuration Vagrant pour les VMs internes
│   ├── ansible/                   — Playbooks et rôles Ansible
│   └── scripts/                   — Scripts utilitaires pour l'automatisation
├── docs/
│   ├── README.md
│   ├── SETUP/
│   │    ├── prereqs.md           — Prérequis matériels et logiciels
│   │    ├── VMs_installation.md  — Guide détaillé d'installation et de configuration des VMs
│   │    ├── pfsense_setup.md     — Documentation d'installation et de configuration de pfSense
│   │    ├── Web_server_setup.md  — Guide de déploiement du serveur web
│   │    ├── Wazuh_setup.md       — Guide d'installation de Wazuh et d'enrôlement des agents
│   │    └── GOAD_setup.md        — Procédure de déploiement de l'Active Directory GOAD
│   └── TESTS/
│        ├── Web_server.md        — Check-list de validation du serveur web
│        ├── pfSense.md           — Vérifications pfSense et Suricata
│        ├── Wazuh.md             — Tests/documentation Wazuh
│        └── GOAD-MINILAB.md      — Documentation des vérifications GOAD MINILAB
├── CONFIGS/
│   ├── web-server/                — Fichiers de configuration du serveur web (Nginx, Docker, etc.)
│   └── pfsense/                   — Fichiers de configuration pfSense (règles, exports XML)
```

## Démarrage rapide

> **⚠️ Avertissement de sécurité** : Ce lab contient des services intentionnellement vulnérables. **Ne jamais** connecter ces machines à un réseau de production. Changez toujours les mots de passe par défaut après l'installation. Cet environnement est conçu pour un usage isolé et éducatif uniquement.

### Option 1 : Déploiement automatisé (recommandé)

**Lab4PurpleSec** fournit un déploiement semi-automatisé via Vagrant et Ansible pour la plupart des VMs internes.

**Démarrage rapide :**

Sous Windows :
```powershell
cd automation # Se placer dans le répertoire d'automatisation
$env:VAGRANT_ANSIBLE = "true" # Activer le provisioning Ansible
vagrant up # Démarrer les VMs
```

Sous Linux/macOS :
```bash
cd automation # Se placer dans le répertoire d'automatisation
export VAGRANT_ANSIBLE=true # Activer le provisioning Ansible
vagrant up # Démarrer les VMs
```

**Ce qui est automatisé :**

Le déploiement des VMs suivantes est automatisé :

- LAN-SIEM-LIN (Wazuh Manager)
- LAN-TEST-LIN (Ubuntu Desktop avec interface graphique)
- LAN-ATTACK-LIN (Kali Linux)
- WAN-ATTACK-LIN (Kali Linux)
- DMZ-WEB01-LIN (serveur web Debian)

**Ce qui nécessite encore une configuration manuelle :**

- Firewall pfSense (installation manuelle depuis l'ISO)
- GOAD MINILAB (dépôt externe)
- Metasploitable2/3 (dépôts externes)
- Agents Wazuh sur Windows/pfSense
- Applications du serveur web (Docker Compose)
- Configurations réseau (pfSense, Suricata, Wazuh, GOAD, etc.)

**Voir :**

- `automation/README.md` pour la documentation détaillée de l'automatisation
- `automation/ORCHESTRATION.md` pour l'orchestration complète du déploiement
- `docs/SETUP/README.md` pour les guides d'installation manuelle détaillés

### Option 2 : Déploiement manuel

Pour une installation manuelle complète (à but éducatif) :

1. Prérequis (voir `docs/SETUP/prereqs.md`) :
   - Hyperviseur (VMware Workstation / VirtualBox / Hyper-V)
     > **Note** : Ce lab peut être réalisé sous VirtualBox si besoin, mais j'ai personnellement utilisé VMware Workstation Pro pour cette documentation.
   - Images ISO nécessaires pour l'installation des systèmes d'exploitation
   - Connexion internet pour télécharger les dépendances et outils
2. Installation des VMs (hors GOAD-MINILAB).
3. Créer 3 réseaux / interfaces sur l'hyperviseur (cf. `docs/SETUP/prereqs.md`) :
   1. Exemple pour la VM pfSense (3 cartes réseau) :
      - WAN virtuel : Mode Pont/Bridged (DHCP)
      - LAN : Segment LAN en 192.168.10.0/24
      - DMZ : Segment LAN en 192.168.20.0/24
4. Déployer pfSense (cf. `docs/SETUP/pfsense_setup.md`) :
   1. Configurer les interfaces précédentes.
   2. Assigner les adresses IP sur les interfaces.
   3. Accéder à l'interface web de pfSense et vérifier les configurations précédentes.
   4. Ajouter les règles de pare-feu.
   5. Configurer la règle NAT pour le reverse proxy Nginx.
5. Déployer Suricata sur pfSense (cf. `docs/SETUP/pfsense_setup.md`).
6. Déployer Wazuh Manager (SIEM) puis les agents sur les cibles (Linux/Windows). Voir `docs/SETUP/Wazuh_setup.md`.
7. Mettre en place GOAD et les postes clients Windows, puis les intégrer dans le LAN. Voir `docs/SETUP/GOAD_setup.md`.
8. Lancer les tests de vérification depuis `docs/TESTS/` pour s'assurer que tout est correctement configuré.

Vous pouvez maintenant profiter de **Lab4PurpleSec** comme vous le souhaitez !

Vous pouvez :

- Ajouter/Supprimer des machines, outils, technologies librement.
- Modifier les paramètres des différentes machines du lab en fonction de votre scénario.
- Utiliser le lab tel quel.
- Réaliser divers scénarios Purple Team (votre créativité est la seule limite !).

> **Note** : La VM/routeur pfSense (FW-PFSENSE) doit être démarrée systématiquement pour que le lab fonctionne correctement.

**Voir :** `docs/SETUP/README.md` pour les guides d'installation manuelle détaillés.

## Scénarios possibles

### 1. Pivoting : WAN → DMZ → LAN

**Objectif :** Obtenir un accès initial sur une VM web en DMZ puis pivoter vers une machine du LAN/AD.

**Compétences / outils :** Reconnaissance, Tunnelisation (SSH/SOCKS, proxychains), pivoting.

**Résultats attendus :** logs web + alertes IDS + alertes Wazuh.

**Point à considérer :** Adapter les règles pfSense (simulation d'une mauvaise configuration).

### 2. Exploit Web OWASP → Persistance (webshell)

**Objectif :** Exploiter une vulnérabilité web (upload, RCE ou LFI) sur un service DMZ et établir une persistance limitée.

**Compétences / outils :** tests d'app web, BurpSuite, OWASP Top 10, webshell, injection de commandes, file upload, HTTP.

**Résultats attendus :** logs web + alertes IDS + capture du webshell.

### 3. Kerberoasting (AD) : reconnaissance & récupération de tickets

**Objectif :** Récupérer des tickets de service Kerberos pour attaquer des comptes de service.

**Compétences / outils :** énumération AD, tickets Kerberos, hash cracking.

**Résultats attendus :** logs AD + alertes IDS + logs Wazuh montrant une activité anormale, timeline.

## Installation des composants

**Lab4PurpleSec** prend en charge le déploiement automatisé et manuel :

### Composants automatisés

Les VMs suivantes peuvent être déployées automatiquement via Vagrant et Ansible :

- **LAN-SIEM-LIN, LAN-TEST-LIN, LAN-ATTACK-LIN, WAN-ATTACK-LIN, DMZ-WEB01-LIN**

Voir `automation/README.md` pour les instructions de déploiement automatisé.

### Composants manuels

Les composants suivants doivent être installés manuellement à partir des sources officielles :

- **Firewall pfSense** : Installation manuelle depuis l'image ISO (voir `docs/SETUP/pfsense_setup.md`)
- **GOAD MINILAB** : Installation via Vagrant selon la documentation officielle ([https://orange-cyberdefense.github.io/GOAD/installation/](https://orange-cyberdefense.github.io/GOAD/installation/)) et intégration dans le LAN selon `docs/SETUP/GOAD_setup.md`
- **Metasploitable2/3** : Installation via Vagrant depuis les dépôts officiels Rapid7 ou utilisation des images ISO/VMX disponibles sur leurs sites respectifs
- **Agents Wazuh** : Installation manuelle sur les machines Windows et pfSense (voir `docs/SETUP/Wazuh_setup.md`)
- **Applications du serveur web** : Mise en place manuelle via Docker Compose (voir `docs/SETUP/Web_server_setup.md`)

Consultez `docs/SETUP/prereqs.md` pour la liste complète des images ISO nécessaires et `docs/SETUP/VMs_installation.md` pour les guides d'installation manuelle détaillés.

> **⚠️ Avertissement de sécurité** : Les machines créées contiennent des services intentionnellement vulnérables — **ne jamais** les connecter à un réseau de production. Changez immédiatement les mots de passe par défaut après l'installation. Ce lab est conçu pour un usage isolé et éducatif uniquement.

## Contributions

**_Lab4PurpleSec_** est un projet open-source à but éducatif. Les contributions et retours constructifs sont les bienvenus !

- **Guide de contribution** : Voir [CONTRIBUTING.md](CONTRIBUTING.md) pour savoir comment contribuer
- **Signaler un problème** : Utilisez les [templates d'issues GitHub](.github/ISSUE_TEMPLATE/) pour les rapports de bug, demandes de fonctionnalités ou problèmes de documentation

## Licence

Ce projet est sous la licence MIT.

**Mention de licence :** L'utilisation de ce projet (y compris pour des CTF, des projets commerciaux, de la formation ou tout autre usage) est soumise aux termes et conditions de la licence MIT. Voir `LICENSE` pour les détails complets. En utilisant ce projet, vous acceptez de respecter les termes de la licence, notamment la conservation des mentions de droits d'auteur et des informations de licence.

## Mentions légales

Les logos et marques citées ou représentées dans ce projet sont la propriété de leurs détenteurs respectifs.

L'usage de ces logos est strictement informatif et non commercial.

## Credits

Un grand merci à Orange Cyberdefense pour avoir développé GOAD ([https://orange-cyberdefense.github.io/GOAD](https://orange-cyberdefense.github.io/GOAD)/).
