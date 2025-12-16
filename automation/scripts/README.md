# Scripts d'automatisation - Lab4PurpleSec

Ce répertoire contient les scripts utilisés pour l'automatisation et le provisionnement du lab.

## 📁 Structure

```
scripts/
├── bootstrap-ansible.sh          # Installation d'Ansible via apt
├── bootstrap-external.sh         # Configuration des dépôts externes
├── verify-provisioning.sh        # Vérification du provisionnement
├── check-wsl.ps1                # Vérification WSL (Windows)
├── check-wsl.sh                 # Vérification WSL (Bash)
├── fix-guest-additions.ps1      # Correction Guest Additions
├── fix-guest-additions.sh       # Correction Guest Additions
├── get-vagrant-ports.sh         # Affichage des ports Vagrant
├── init.ps1                     # Initialisation (PowerShell)
├── init.sh                      # Initialisation (Bash)
├── setup-ansible-windows.ps1    # Configuration Ansible sur Windows
├── vagrant-helpers.ps1          # Fonctions helper Vagrant (PowerShell)
└── vagrant-helpers.sh           # Fonctions helper Vagrant (Bash)
```

---

## 🔧 Scripts principaux

### bootstrap-ansible.sh

**Fonction :** Installe Ansible et ses dépendances via `apt` (pas `pip`) pour éviter les conflits PEP 668.

**Usage :**

```bash
# Automatiquement appelé par Vagrant
vagrant provision dmz-web01-lin --provision-with bootstrap-ansible

# Manuellement depuis la VM
sudo /vagrant/scripts/bootstrap-ansible.sh
```

**Compatible avec :**

- Debian 12 (Bookworm)
- Ubuntu 22.04+ (Jammy)
- Kali Linux 2024.x

**Fonctionnalités :**

- ✅ Installation idempotente (peut être relancé sans problème)
- ✅ Gestion automatique des dépôts Ansible
- ✅ Détection automatique de la distribution
- ✅ Gestion des erreurs robuste
- ✅ Logs colorés et informatifs

**Codes de sortie :**

- `0` : Succès
- `1` : Erreur de détection de distribution
- `2` : Erreur de privilèges (root requis)
- `3` : Erreur d'installation d'Ansible

---

### verify-provisioning.sh

**Fonction :** Vérifie que le provisionnement Ansible a réussi en testant les configurations, services et packages.

**Usage :**

```bash
# Depuis l'hôte Windows
vagrant ssh dmz-web01-lin -c "sudo /vagrant/scripts/verify-provisioning.sh"

# Depuis la VM
sudo /vagrant/scripts/verify-provisioning.sh
```

**Tests effectués :**

- ✅ Packages système (Python, Git, cURL, Wget)
- ✅ Services actifs (SSH, Docker, Wazuh)
- ✅ Ports en écoute (22, 443, 1514, 1515, 55000)
- ✅ Fichiers et répertoires (`/opt/webapps`, `/etc/hosts`)
- ✅ Configuration réseau

**Tests par VM :**

| VM               | Tests spécifiques                       |
| ---------------- | --------------------------------------- |
| `dmz-web01-lin`  | Docker, Docker Compose, répertoires web |
| `lan-siem-lin`   | Wazuh Manager, Indexer, Dashboard       |
| `lan-attack-lin` | Outils Kali (Nmap, Metasploit, SQLMap)  |
| `wan-attack-lin` | Outils Kali (Nmap, Metasploit, SQLMap)  |
| `lan-test-lin`   | Tests communs uniquement                |

**Codes de sortie :**

- `0` : Tous les tests ont réussi
- `1` : Au moins un test a échoué

---

### bootstrap-external.sh

**Fonction :** Fournit des instructions et clone optionnellement les dépôts externes (GOAD, Metasploitable3).

**Usage :**

```bash
# Mode interactif
./scripts/bootstrap-external.sh

# Mode automatique (pas de clonage)
./scripts/bootstrap-external.sh --auto
```

**Dépôts gérés :**

- GOAD (Game Of Active Directory)
- Metasploitable3

---

## 🛠️ Scripts utilitaires

### check-wsl.ps1 / check-wsl.sh

**Fonction :** Vérifie que WSL est installé et configuré correctement sur Windows.

**Usage :**

```powershell
# PowerShell
.\scripts\check-wsl.ps1
```

```bash
# Bash (WSL ou Linux)
./scripts/check-wsl.sh
```

---

### fix-guest-additions.ps1 / fix-guest-additions.sh

**Fonction :** Corrige les problèmes de VirtualBox Guest Additions.

**Usage :**

```powershell
# PowerShell (depuis l'hôte)
.\scripts\fix-guest-additions.ps1 dmz-web01-lin
```

```bash
# Bash (depuis la VM)
sudo /vagrant/scripts/fix-guest-additions.sh
```

---

### get-vagrant-ports.sh

**Fonction :** Affiche les ports forwardés par Vagrant.

**Usage :**

```bash
./scripts/get-vagrant-ports.sh
```

---

### init.ps1 / init.sh

**Fonction :** Initialise l'environnement d'automatisation (vérifications, dépendances).

**Usage :**

```powershell
# PowerShell
.\scripts\init.ps1
```

```bash
# Bash
./scripts/init.sh
```

---

### setup-ansible-windows.ps1

**Fonction :** Configure Ansible sur Windows (via WSL).

**Usage :**

```powershell
.\scripts\setup-ansible-windows.ps1
```

---

### vagrant-helpers.ps1 / vagrant-helpers.sh

**Fonction :** Fonctions helper pour Vagrant (sourcing).

**Usage :**

```powershell
# PowerShell
. .\scripts\vagrant-helpers.ps1
Get-VagrantStatus
```

```bash
# Bash
source ./scripts/vagrant-helpers.sh
vagrant_status
```

---

## 📝 Conventions

### Nommage des scripts

- `.ps1` : Scripts PowerShell (Windows)
- `.sh` : Scripts Bash (Linux/WSL)

### Styles de sortie

Les scripts utilisent des logs colorés :

- 🔵 **[INFO]** : Information
- 🟢 **[✓]** : Succès
- 🟡 **[!]** : Avertissement
- 🔴 **[✗]** : Erreur

### Codes de sortie

- `0` : Succès
- `1-10` : Erreurs génériques
- `11-20` : Erreurs de dépendances
- `21-30` : Erreurs de configuration

---

## 🧪 Tests

Pour tester les scripts individuellement :

```bash
# Test bootstrap-ansible
vagrant ssh dmz-web01-lin -c "sudo /vagrant/scripts/bootstrap-ansible.sh"

# Test verify-provisioning
vagrant ssh dmz-web01-lin -c "sudo /vagrant/scripts/verify-provisioning.sh"

# Test bootstrap-external
./scripts/bootstrap-external.sh --auto
```

---

## 🐛 Dépannage

### Script ne s'exécute pas

**Vérifiez les permissions :**

```bash
# Depuis l'hôte Windows (Git Bash ou WSL)
chmod +x scripts/*.sh

# Depuis la VM
sudo chmod +x /vagrant/scripts/*.sh
```

### Erreur "line endings"

Si vous voyez des erreurs `^M` ou `\r\n` :

```bash
# Convertir les fins de ligne (DOS → Unix)
dos2unix scripts/*.sh

# Ou manuellement
sed -i 's/\r$//' scripts/*.sh
```

### Logs détaillés

Pour activer les logs détaillés, ajoutez en début de script :

```bash
# Debug mode
set -x

# Ou
bash -x /vagrant/scripts/script.sh
```

---

## 📚 Ressources

- **automation/README.md** - Documentation de l'automatisation
- **automation/ansible/README.md** - Documentation Ansible
- **../docs/SETUP/** - Guides d'installation manuelle

---

## 🔗 Liens utiles

- [Vagrant Documentation](https://www.vagrantup.com/docs)
- [Ansible Documentation](https://docs.ansible.com/)
- [Bash Best Practices](https://google.github.io/styleguide/shellguide.html)
- [PowerShell Best Practices](https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/cmdlet-development-guidelines)

---

**Dernière mise à jour :** 2024-11-20
