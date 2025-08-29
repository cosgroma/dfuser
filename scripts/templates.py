COMP_DOC = """
# {{ component_name }}

## Basic Information
- **Name**: {{ component.BasicInformation.Name }}
- **Description**: {{ component.BasicInformation.Description }}
- **Version**: {{ component.BasicInformation.Version }}
- **Owner**: {{ component.BasicInformation.Owner }}

## Functional Attributes
### Responsibilities
{% for responsibility in component.FunctionalAttributes.Responsibilities %}
- {{ responsibility }}
{% endfor %}

### Functions
{% for function_name, function_description in component.FunctionalAttributes.Functions.items() %}
- **{{ function_name }}**: {{ function_description }}
{% endfor %}

- **Inputs**: {{ component.FunctionalAttributes.Inputs }}
- **Outputs**: {{ component.FunctionalAttributes.Outputs }}
- **Algorithms**: {{ component.FunctionalAttributes.Algorithms }}

## Interaction Attributes
- **Dependencies**: {{ component.InteractionAttributes.Dependencies }}
- **Consumers**: {{ component.InteractionAttributes.Consumers }}
- **Communication**: {{ component.InteractionAttributes.Communication }}

## Performance and Reliability
- **Latency**: {{ component.PerformanceAndReliability.Latency }}
- **Throughput**: {{ component.PerformanceAndReliability.Throughput }}
- **Availability**: {{ component.PerformanceAndReliability.Availability }}
- **Fault Tolerance**: {{ component.PerformanceAndReliability.FaultTolerance }}

## Security and Privacy
- **Access Control**: {{ component.SecurityAndPrivacy.AccessControl }}
- **Data Protection**: {{ component.SecurityAndPrivacy.DataProtection }}
- **Audit Logging**: {{ component.SecurityAndPrivacy.AuditLogging }}

## Deployment and Operation
- **Environment**: {{ component.DeploymentAndOperation.Environment }}
- **Resource Requirements**: {{ component.DeploymentAndOperation.ResourceRequirements }}
- **Monitoring**: {{ component.DeploymentAndOperation.Monitoring }}
- **Update and Maintenance**: {{ component.DeploymentAndOperation.UpdateAndMaintenance }}

## Documentation and Support
- **Documentation**: {{ component.DocumentationAndSupport.Documentation }}
- **Support**: {{ component.DocumentationAndSupport.Support }}
- **Community**: {{ component.DocumentationAndSupport.Community }}
"""

PRESENTATION_DOC = """
# {{ component_name }}

## {{ attribute_name }}
{{ attribute_content }}
"""

PLANTUML_DOC = """
@startuml
{% for component_name, component in components.items() %}
component {{ component_name }} {
{% for function_name, function_description in component.FunctionalAttributes.Functions.items() %}
- {{ function_name }}(): {{ function_description }}
{% endfor %}
}
{% endfor %}
@enduml
"""

