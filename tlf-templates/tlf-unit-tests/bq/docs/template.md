# My Module

## Description

{{.Module.Description }}

## Inputs

| Name | Description | Type | Default |
|---|---|---|---|
{{ range.Inputs }}| {{.Name }} | {{.Description }} | {{.Type }} | {{.Default }} |
{{ end }}

## Outputs

| Name | Description |
|---|---|
{{ range.Outputs }}| {{.Name }} | {{.Description }} |
{{ end }}
