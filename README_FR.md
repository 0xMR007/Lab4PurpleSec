![Lab4PurpleSec](/assets/images/icons/Lab4PurpleSec-icon-7-5.png)

# Lab4PurpleSec

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Status](https://img.shields.io/badge/status-active-success.svg)
![Platform](https://img.shields.io/badge/platform-VMware%20%7C%20VirtualBox%20%7C%20Hyper--V-lightgrey.svg)
![Maintenance](https://img.shields.io/badge/maintained-yes-green.svg)

> **Note** : Ce projet s'appelait précédemment "Lab4OffSec" et a été renommé en "Lab4PurpleSec" pour mieux refléter son orientation Purple Team.

![🌍 English version available here](/README.md)

Sommaire

- [Lab4PurpleSec](#lab4purplesec)
  - [Présentation](#présentation)
    - [Objectifs du projet](#objectifs-du-projet)
  - [TL;DR](#tldr)
  - [Architecture réseau](#architecture-réseau)
    - [Lab4PurpleSec](#lab4purplesec-1)
    - [GOAD-MINILAB](#goad-minilab)
  - [Structure du projet](#structure-du-projet)
  - [Quick start](#quick-start)
    - [Automatisation future](#automatisation-future)
  - [Scénarios possibles](#scénarios-possibles)
    - [1. Pivoting : WAN → DMZ → LAN](#1-pivoting--wan--dmz--lan)
    - [2. Exploit Web OWASP → Persistence (webshell)](#2-exploit-web-owasp--persistence-webshell)
    - [3. Kerberoasting (AD) : reconnaissance \& récupération de tickets](#3-kerberoasting-ad--reconnaissance--récupération-de-tickets)
  - [Installation des composants](#installation-des-composants)
  - [Contributions](#contributions)
  - [Licence](#licence)
  - [Mentions légales](#mentions-légales)
  - [Credits](#credits)

## Présentation

Lab4PurpleSec est un homelab évolutif de cybersécurité conçu pour l'entraînement Red Team et Blue Team dans un contexte proche d'un environnement d'entreprise, intégrant pentest réseau/web, Active Directory, détection, SIEM et IDS/IPS.

Projet destiné aux étudiants et passionnés de cyber !

### Objectifs du projet

**Lab4PurpleSec** ne fournit pas de machines virtuelles préconstruites (OVA/OVF). L'installation se fait entièrement "from scratch" en suivant les guides détaillés fournis. Cette approche :

- **Encourage l'apprentissage** : Comprendre chaque étape d'installation et de configuration
- **Assure la reproductibilité** : Chaque utilisateur construit son environnement de manière identique (mais tout de même personnalisable)
- **Renforce la compréhension** : Maîtrise des systèmes, des réseaux et des configurations
- **Facilite la personnalisation** : Adaptation facile selon les besoins spécifiques

## TL;DR

**Lab4PurpleSec** dispose des caractéristiques suivantes :

- Architecture segmentée (WAN, DMZ, LAN, AD)
- Firewall pfSense, IDS/IPS Suricata, SIEM Wazuh
- Machines vulnérables type OWASP, Metasploitable, DC Windows
- Guides détaillés d'installation et de configuration

## Architecture réseau

### Lab4PurpleSec

Lab4PurpleSec est un environnement dédié à l'exploitation de vulnérabilités applicatives et systèmes, hébergeant des machines intentionnellement vulnérables (Metasploitable2/3), des applications web OWASP dans une zone DMZ isolée ainsi qu’un environnement Active Directory vulnérable (GOAD MINILAB).

![Homelab-light.png](/assets/images/Diagrams/Homelab-light.png)

### GOAD-MINILAB

GOAD-MINILAB reproduit un environnement Active Directory simplifié avec un contrôleur de domaine et un poste client Windows (plusieurs si nécessaire), permettant de simuler divers types d’attaques orientées Active Directory.

![GOAD-MINILAB.png](/assets/images/Diagrams/GOAD-MINILAB.png)

## Structure du projet

Cette section présente l'organisation du dépôt **Lab4PurpleSec** et décrit le rôle de chaque répertoire et fichier principal. Cette structure permet une navigation claire entre les guides d'installation, les configurations, les tests et les ressources du projet.

```
Lab4PurpleSec/
├─ README_FR.md               — Présentation générale du projet.
├─ ARCHITECTURE.md            — Informations sur l'architecture de Lab4PurpleSec.
├─ /assets/                   — Dossier contenant les ressources visuelles telles (images, diagrammes, etc.).
├─ INVENTORY.md               — Liste descriptive des machines virtuelles et de leurs caractéristiques principales.
├─ Docs/
│  ├─ README.md
│  ├─ SETUP/
│  │   ├─ prereqs.md             — Prérequis de déploiement pour le lab.
│  │   ├─ VMs_installation.md     — Guides d'installation et de configuration des machines virtuelles.
│  │   ├─ pfsense_setup.md        — Guide d'installation et de configuration de pfSense.
│  │   ├─ Web_server_setup.md    — Guide d'installation et de configuration du serveur web.
│  │   ├─ Wazuh_setup.md          — Guide d'installation et de configuration de Wazuh et ses agents.
│  │   └─ GOAD_setup.md           — Guide d'installation et de configuration de GOAD MINILAB.
│  └─ TESTS/
│     ├─ Web_server.md     — Guide de tests pour le serveur web.
│     ├─ pfSense.md        — Guide de tests pour pfSense et Suricata.
│     ├─ Wazuh.md          — Guide de tests pour Wazuh.
│     └─ GOAD-MINILAB.md   — Guide de tests pour GOAD MINILAB.
├─ CONFIGS/
│  ├─ web-server/      — Fichiers de configuration liés au serveur web.
│  └─ pfsense/         — Fichier(s) de configuration pour pfSense.
├─ LICENSE             — Informations sur la licence et les droits d'utilisation.
└─ .gitignore          — Liste des fichiers et dossiers exclus du suivi de version.
```

## Quick start

1. Prérequis (Voir `Docs/SETUP/prereqs.md`) :
   - Hyperviseur (VMware Workstation / VirtualBox / Hyper-V)
     > **Note** : Ce lab peut être réalisé sous VirtualBox si besoin, mais j'ai personnellement utilisé VMware Workstation Pro pour cette documentation.
   - Images ISO nécessaires pour l'installation des systèmes d'exploitation
   - Connexion internet pour télécharger les dépendances et outils
2. Installation des VMs (Hors GOAD-MINILAB).
3. Créer 3 réseaux / interfaces sur l'hyperviseur (cf. `Docs/SETUP/prereqs.md`) :
   1. Exemple pour VM pfSense (3 cartes réseau):
      - WAN virtuel : Mode Pont/Bridged (DHCP)
      - LAN : Segment LAN en 192.168.10.0/24
      - DMZ : Segment LAN en 192.168.20.0/24
4. Déployer pfSense (cf. `Docs/SETUP/pfsense_setup.md`) :
   1. Configurer les interfaces précédentes.
   2. Assigner les adresses IP sur les interfaces.
   3. Accéder à l’interface web de pfSense et vérifier les configurations précédentes.
   4. Ajouter les règles de pare-feu.
   5. Configurer la règle NAT pour le reverse proxy Nginx.
5. Déployer Suricata sur pfSense (cf. `Docs/SETUP/pfsense_setup.md`).
6. Déployer Wazuh Manager (SIEM) puis les agents sur les cibles (Linux/Windows). Voir `Docs/SETUP/Wazuh_setup.md`.
7. Mettre en place GOAD MINILAB, puis intégration dans le LAN. Voir `Docs/SETUP/GOAD_setup.md`.
8. Lancer les tests de vérification (cf. `Docs/TESTS/`). Voir `Docs/TESTS/README.md` pour la liste des tests disponibles.

### Automatisation future

> **Note** : Des scripts d'automatisation (Infrastructure as Code) sont prévus pour une future version du projet afin de faciliter le déploiement. Pour l'instant, l'installation se fait manuellement en suivant les guides détaillés.

> **Note** : La VM/routeur pfSense (FW-PFSENSE) doit être lancé systématiquement pour que le lab fonctionne.

Vous pouvez maintenant profiter de **Lab4PurpleSec** comme vous le souhaitez !

Vous pouvez :

- Ajouter/Supprimer des machines, outils, technologies librement.
- Modifier les paramètres des différentes machines du lab en fonction de votre scénario.
- Utiliser le lab tel quel.
- Réaliser divers scénarios Purple team.

## Scénarios possibles

### 1. Pivoting : WAN → DMZ → LAN

**Objectif :** Obtenir un accès initial sur une VM web en DMZ puis pivoter vers une machine du LAN/AD.

**Compétences / outils :** Reconnaissance, Tunnelisation (SSH/SOCKS, proxychains), pivoting.

**Résultats attendus :** logs web + alertes IDS + alertes Wazuh.

**Point à considérer :** Adapter les règles pfSense (simulation d'une mauvaise configuration).

### 2. Exploit Web OWASP → Persistence (webshell)

**Objectif :** Exploiter une vulnérabilité web (upload, RCE ou LFI) sur un service DMZ et établir une persistance limitée.

**Compétences / outils :** tests d’app web, BurpSuite, OWASP Top 10, webshell, injection de commandes, file upload, HTTP.

**Résultats attendus :** logs web + alertes IDS + capture du webshell.

### 3. Kerberoasting (AD) : reconnaissance & récupération de tickets

**Objectif :** Récupérer des tickets de service Kerberos pour attaquer des comptes de service.

**Compétences / outils :** énumération AD, tickets Kerberos, hash cracking.

**Résultats attendus :** logs AD + alertes IDS + logs Wazuh montrant activité anormale, timeline.

## Installation des composants

Tous les composants de **Lab4PurpleSec** sont installés manuellement à partir des sources officielles :

- **GOAD MINILAB** : Installation via Vagrant selon la documentation officielle ([https://orange-cyberdefense.github.io/GOAD/installation/](https://orange-cyberdefense.github.io/GOAD/installation/)) et intégration dans le LAN selon `Docs/SETUP/GOAD_setup.md`
- **Metasploitable2/3** : Installation via Vagrant depuis les dépôts officiels Rapid7 ou utilisation des images ISO/VMX disponibles sur leurs sites respectifs
- **Autres VMs** : Installation depuis les images ISO officielles (Kali Linux, Debian, Ubuntu, Windows, pfSense)

Consultez `Docs/SETUP/prereqs.md` pour la liste complète des images ISO nécessaires et `Docs/SETUP/VMs_installation.md` pour les guides d'installation détaillés.

<aside>

**Attention** : Les machines créées contiennent des services vulnérables par conception — **ne jamais** les connecter à un réseau de production. Changez immédiatement les mots de passe par défaut après l'installation.

</aside>

## Contributions

**_Lab4PurpleSec_** est un projet open-source à but éducatif. Les contributions et retours constructifs sont les bienvenus. Pour toute remarque ou suggestion, merci d'ouvrir une issue sur le dépôt.

## Licence

Ce projet est sous la licence MIT.

## Mentions légales

Les logos et marques citées ou représentées dans ce projet sont la propriété de leurs détenteurs respectifs.
L'usage de ces logos est strictement informatif et non commercial.

## Credits

Un grand merci à Orange Cyberdefense pour avoir développé GOAD ([https://orange-cyberdefense.github.io/GOAD](https://orange-cyberdefense.github.io/GOAD/)/).
