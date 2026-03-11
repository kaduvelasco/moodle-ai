# Plugin Runtime Flow

Este arquivo descreve o fluxo de execução do plugin.

Ele ajuda ferramentas de IA a entender:

- pontos de entrada do plugin
- arquivos principais envolvidos na execução
- integração com eventos, tasks e services

---

## Estrutura

Fluxo típico:

entrypoint → lib/locallib → classes → events/tasks/services

---

## Entry Points

Arquivos que podem iniciar execução do plugin.

---

## Core Logic

Arquivos onde a lógica principal do plugin geralmente fica.

---

## Classes

Classes encontradas no diretório classes/.

---

## Events

Eventos definidos pelo plugin.

---

## Tasks

Scheduled ou adhoc tasks.

---

## Web Services

Funções expostas via API.
