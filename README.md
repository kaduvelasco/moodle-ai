# moodle-ai

CLI para geração de **contexto estruturado de projetos Moodle** para uso com ferramentas de **IA no desenvolvimento**.

O objetivo do projeto é facilitar o entendimento da estrutura de uma instalação do **Moodle** e de seus plugins, gerando documentação automática que pode ser utilizada por assistentes de código, ferramentas de análise e desenvolvedores.

---

# Versão Atual

**Version:** 1.0
**Status:** Estável (Base funcional completa)

A versão 1.0 fornece uma CLI simples que permite:

* Inicializar contexto de uma instalação Moodle
* Gerar contexto de plugins em desenvolvimento
* Atualizar índices de contexto

---

# Objetivo do Projeto

Projetos Moodle possuem uma estrutura grande e complexa, com múltiplos tipos de plugins e diversas APIs internas.

Este projeto cria **arquivos de contexto estruturado** para ajudar ferramentas de IA a compreender:

* Estrutura do Moodle
* APIs disponíveis
* Eventos
* Tasks
* Estrutura de plugins
* Tabelas de banco de dados
* Dependências

Isso melhora significativamente a qualidade das sugestões de código e da análise automatizada.

---

# Estrutura do Projeto

```
moodle-ai/
│
├─ bin/
│   └─ moodle-ai
│
├─ commands/
│   ├─ init.sh
│   ├─ plugin.sh
│   └─ update.sh
│
├─ lib/
│   ├─ utils.sh
│   ├─ moodle-detect.sh
│   ├─ plugin-detect.sh
│   ├─ generators.sh
│   ├─ indexers.sh
│   └─ validators.sh
│
└─ templates/
    ├─ AI_CONTEXT.md.tpl
    ├─ MOODLE_PLUGIN_GUIDE.md.tpl
    ├─ MOODLE_DEV_RULES.md.tpl
    ├─ MOODLE_API_INDEX.md.tpl
    ├─ MOODLE_EVENTS_INDEX.md.tpl
    ├─ MOODLE_TASKS_INDEX.md.tpl
    ├─ PLUGIN_CONTEXT.md.tpl
    ├─ PLUGIN_STRUCTURE.md.tpl
    ├─ PLUGIN_DB_TABLES.md.tpl
    ├─ PLUGIN_EVENTS.md.tpl
    └─ PLUGIN_DEPENDENCIES.md.tpl
```

---

# Instalação

Clone o projeto:

```
git clone <repo>
```

Torne o comando executável:

```
chmod +x bin/moodle-ai
```

Opcionalmente, crie um link global:

```
sudo ln -s /caminho/moodle-ai/bin/moodle-ai /usr/local/bin/moodle-ai
```

Depois disso o comando pode ser executado diretamente:

```
moodle-ai
```

---

# Comandos Disponíveis

## Inicializar contexto do Moodle

```
moodle-ai init
```

Pergunta:

* Caminho da instalação Moodle
* Versão do Moodle

Arquivos gerados na raiz do projeto:

```
AI_CONTEXT.md
MOODLE_PLUGIN_GUIDE.md
MOODLE_DEV_RULES.md

MOODLE_API_INDEX.md
MOODLE_EVENTS_INDEX.md
MOODLE_TASKS_INDEX.md

PLUGIN_MAP.md
tags
```

---

## Gerar contexto de plugin

```
moodle-ai plugin caminho/para/plugin
```

Exemplo:

```
moodle-ai plugin local/meuplugin
```

O sistema detecta automaticamente:

* Tipo do plugin
* Nome
* Component

Arquivos gerados no plugin:

```
PLUGIN_CONTEXT.md
PLUGIN_STRUCTURE.md
PLUGIN_DB_TABLES.md
PLUGIN_EVENTS.md
PLUGIN_DEPENDENCIES.md
```

Também é criado um arquivo:

```
.kaduvelasco
```

Esse arquivo marca o plugin como **plugin em desenvolvimento**.

---

## Atualizar índices

```
moodle-ai update
```

Regenera:

```
MOODLE_API_INDEX.md
MOODLE_EVENTS_INDEX.md
MOODLE_TASKS_INDEX.md
PLUGIN_MAP.md
tags
```

---

# Arquivos de Contexto Gerados

Arquivos globais:

```
AI_CONTEXT.md
MOODLE_PLUGIN_GUIDE.md
MOODLE_DEV_RULES.md
MOODLE_API_INDEX.md
MOODLE_EVENTS_INDEX.md
MOODLE_TASKS_INDEX.md
```

Arquivos de plugin:

```
PLUGIN_CONTEXT.md
PLUGIN_STRUCTURE.md
PLUGIN_DB_TABLES.md
PLUGIN_EVENTS.md
PLUGIN_DEPENDENCIES.md
```

Esses arquivos permitem que ferramentas de IA compreendam melhor a estrutura do projeto.

---

# Dependências

Ferramentas necessárias:

* PHP
* ctags
* git
* bash

O projeto foi desenvolvido para ambientes Linux.

---

# Roadmap

## Versão 2 – Indexação Real do Código

Melhorar geração de índices lendo o código real do Moodle.

Novas capacidades:

* Extração automática de APIs do diretório `lib/`
* Extração automática de eventos (`db/events.php`)
* Extração automática de tasks (`db/tasks.php`)
* Extração automática de services (`db/services.php`)
* Extração automática de tabelas (`db/install.xml`)

---

## Versão 3 – Detecção Automática do Plugin Ativo

Detecção automática do plugin em edição dentro do editor.

Objetivo:

* identificar plugin ativo no projeto
* carregar automaticamente o contexto correto

---

## Versão 4 – Plugins em Lote

Gerar contexto automaticamente para todos os plugins marcados com:

```
.kaduvelasco
```

Novo comando planejado:

```
moodle-ai plugin-batch
```

---

## Versão 5 – Diagnóstico do Ambiente

Adicionar comando:

```
moodle-ai doctor
```

Capaz de verificar:

* instalação Moodle válida
* dependências do sistema
* índices desatualizados
* plugins incompletos

---

# Futuro do Projeto

Possíveis evoluções:

* indexação completa da API do Moodle
* suporte a múltiplas instalações
* análise de dependências entre plugins
* geração automática de documentação de plugins
* integração com ferramentas de IA

---

# Licença

Projeto open-source para apoio ao desenvolvimento Moodle.

---

