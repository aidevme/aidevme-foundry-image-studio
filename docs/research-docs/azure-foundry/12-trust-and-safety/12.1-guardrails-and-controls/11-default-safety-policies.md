# Default Guardrail policies for Azure OpenAI

| Field | Value |
| --- | --- |
| **Document Title** | Default Guardrail policies for Azure OpenAI |
| **Document Location** | `docs/research-docs/azure-foundry/12-trust-and-safety/12.1-guardrails-and-controls/11-default-safety-policies.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Default Guardrail policies for Azure OpenAI". Learn about the default Guardrail policies that Azure OpenAI uses to flag content and ensure responsible use of the service. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/openai/concepts/default-safety-policies). Article date: 2026-05-31. Page updated: 2026-07-30. Retrieved: 2026-09-29. Navigation: Trust and safety > Guardrails and controls > Default safety policies.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Azure OpenAI in Microsoft Foundry Models includes default safety policies that apply to all models, excluding transcription models. These configurations provide a responsible experience by default, including [content filtering models](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/concepts/content-filter?tabs=warning%2Cpython-new), blocklists, prompt transformation, [content credentials](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/concepts/content-credentials), and other features.

Guardrails and controls ensure that AI-generated outputs align with ethical guidelines and safety standards. Azure OpenAI provides Guardrail capabilities to help identify and mitigate risks associated with various categories of harmful or inappropriate content. Default safety aims to mitigate risks in different categories such as hate and fairness, sexual, violence, self-harm, protected material content, and user prompt injection attacks. To learn more, see [categories and severity levels](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/concepts/content-filter?tabs=warning%2Cpython-new).

All safety policies are configurable. To learn more about configurability, see [configuring Guardrails](https://learn.microsoft.com/en-us/azure/ai-foundry/openai/how-to/content-filters).

When content is detected that exceeds the severity threshold for a risk category, the API request is blocked and returns an error response indicating which category triggered the filter. This applies to both user prompts (input) and model completions (output).

## Prerequisites

- An Azure subscription with access to Azure OpenAI Service
- Deployed Azure OpenAI models (excluding transcription models, which use different safety configurations)

## Text models

Text models in Azure OpenAI can take in and generate both text and code. These models leverage Azure's text content filters to detect and prevent harmful content. This system works on both prompts and completions.

| Risk category | Prompt or completion | Severity threshold |
| --- | --- | --- |
| Hate and fairness | Prompts and completions | Medium |
| Violence | Prompts and completions | Medium |
| Sexual | Prompts and completions | Medium |
| Self-harm | Prompts and completions | Medium |
| User prompt injection attack (jailbreak) | Prompts | N/A |
| Protected material – text | Completions | N/A |
| Protected material – code | Completions | N/A |

## Vision models

### Vision-enabled chat models

| Risk category | Prompt or completion | Severity threshold |
| --- | --- | --- |
| Hate and fairness | Prompts and completions | Medium |
| Violence | Prompts and completions | Medium |
| Sexual | Prompts and completions | Medium |
| Self-harm | Prompts and completions | Medium |
| Identification of individuals and inference of sensitive attributes | Prompts | N/A |
| User prompt injection attack (jailbreak) | Prompts | N/A |

### Image generation models

| Risk category | Prompt or completion | Severity threshold |
| --- | --- | --- |
| Hate and fairness | Prompts and completions | Medium |
| Violence | Prompts and completions | Medium |
| Sexual | Prompts and completions | Medium |
| Self-harm | Prompts and completions | Medium |
| Content credentials | Completions | N/A |
| Deceptive generation of political candidates | Prompts | N/A |
| Depictions of public figures | Prompts | N/A |
| User prompt injection attack (jailbreak) | Prompts | N/A |
| Protected material – art and studio characters | Prompts | N/A |
| Profanity | Prompts | N/A |

## Audio models

| Risk category | Prompt or completion | Severity threshold |
| --- | --- | --- |
| Hate and fairness | Prompts and completions | Medium |
| Violence | Prompts and completions | Medium |
| Sexual | Prompts and completions | Medium |
| Self-harm | Prompts and completions | Medium |
| User prompt injection attack (jailbreak) | Prompts | N/A |
| Protected material - text | Completions | N/A |
| Protected material - code | Completions | N/A |

## Severity levels

> **Note**
>
> The text content filtering models for the hate, sexual, violence, and self-harm categories are specifically trained and tested on the following languages: English, German, Japanese, Spanish, French, Italian, Portuguese, and Chinese. However, the service can work in many other languages, but the quality might vary. In all cases, you should do your own testing to ensure that it works for your application.

## Four-level text content

**[Warning]**

> **Warning**
>
> The **Severity definitions** tab in this document contains examples of harmful content that may be disturbing to some readers.

**[Severity definitions]**

### Hate and fairness severity levels

| **Severity Level** | **Description** | **Example Text** |
| --- | --- | --- |
| Safe | Content is safe but may contain hate and fairness related terms used in generic and safe contexts such as: Education Media Official statistics History Medicine Science Other similar contexts | `Black people should not be killed by police or mistreated just because of their skin color.` |
| Low | Content that contains positive characterization or protection of the Identity groups, displays discrimination, stereotypes and prejudiced, judgmental, or opinionated views or attitudes related to hate speech or targeting identity groups. This includes: Slurs in research papers, dictionaries, or media with a direct quote General hate speech that targets objects, individuals or groups Limited hate speech or depictions of negative sentiment in fictional contexts (for example, gaming, movies, literature) | `I hate you! You are so stupid.` |
| Medium | Content that contains insults, bullying, intimidation, de-humanization or derogation of individuals or groups. This includes: Language that is mocking and imitating Identity groups attributes Describing individuals or groups as inferior or deficient Denying or demeaning identity groups existence Texts that deny historical, well-documented, and violent events such as Holocaust, enslavement, or colonization | `Old people should not be hired to work, especially with computers. They need to stay in nursing homes.` |
| High | Content that contains hate speech as propaganda threatening or calling for violence against Identity groups, radicalizes, recruits or incites people to join extremist efforts or spread hate speech. This includes: Incendiary, offensive, and vulgar language targeting specific individuals or identity groups Claims of superiority to justify discrimination, segregation, or exclusion Texts that contain any form of glorification of Nazi and SS symbolism, KKK and the confederate flag outside of historical, educational, or artistic settings Texts that display hate crime preparation, praise and glorification of violence against Identity groups, or that praise, glorify, or endorse genocide | `[Identity Group] threaten our existence, so we should wipe them out.` |

### Sexual severity levels

| **Severity Level** | **Description** | **Example Text** |
| --- | --- | --- |
| Safe | Content is safe but may contain sexually related terms used in generic and safe contexts such as: Education Media Official statistics History Medicine Science Mentions of family or romantic relations | `Fewer young adults are having sex than in previous generations.` |
| Low | Content that expresses prejudiced, judgmental or opinionated views on sexually related topics or mentions sexually related terms in fictional or real-world experiences that are not extremely graphic. This includes: Mentions of sexual anatomy or sex scenes in fictional and artistic contexts Medical prescriptions and diagnosis Personal experiences, sexual problems and traumas with some graphic content including coping mechanisms and resources | `These soft pajamas are so lovely and have a built-in bra. It makes me feel sexy when I wear them.` |
| Medium | Content that describes sexual arousal and activity in explicit and graphic terms, includes fantasies about sex and sexual abuse. This includes: Mentions of sexual stimulation and masturbation Pornography limited to business and prostitution, escort, etc. as careers without sex scenes Advertisement for adult products such as sex toys Personal experiences and descriptions related to sexual, erotic or tantric massages, strip clubs, erotic shows, BDSM attributes and practices | `We both climaxed at the same time.` |
| High | Content describing solicitation of sexual commercial services, containing detailed descriptions of sexual activity, violent sexual abuse and rape, and non-consensual power exchanges, abuse, and voyeurism. This also includes content that is used to promote, endorse, or glorify extreme or illegal sexual acts. This includes: Any depiction of Child Sexual Abuse Material (CSAM) including any explicit or potential reference to underage sex Child grooming, child abuse, and other child exploitation Explicit or potential references to incest, zoophilia, necrophilia, etc. Human sex trafficking recruitment, including victim manipulation | `I was abused as a child by my uncle and I liked it. Nowadays, I make money by producing child pornography with my neighbor’s 6 year old son.` |

### Violence severity levels

| **Severity Level** | **Description** | **Example Text** |
| --- | --- | --- |
| Safe | Content is safe but may contain terms related to violence used in generic and safe contexts such as: Education Media Official statistics History Medicine Science Common objects when not used as weapons Hunting or shooting sport and guns technical specifications | `Thanks, I had a blast! You are the bomb!` |
| Low | Content in fictional contexts (for example, gaming, literature, arts) that depict violent or graphic scenes without glorification, endorsement or mal-intent. This includes: Personal experiences of violence (without violent intent) Biased, prejudiced, judgmental, or opinionated views on violence Mentions of violent acts and death at low intensity | `Physical punishment is a way to correct bad behavior and doesn’t cause harm to children.` |
| Medium | Content that contains graphic depictions of violence and death at medium intensity as well as fantasies about violent acts or threats. This includes: Texts that put the victim at fault or depict perpetrators in a positive light Historical references to genocide and the Holocaust without endorsement or glorification References to known mass shootings without endorsement or glorification References to terrorist and violent extremist groups and events without endorsement or glorification Texts that seek advice or recommendation or texts that provide instructions on how to perform a violent act against an animal, an individual, a group of individuals or an object or infrastructure that can result in individual or mass harm Bullying and intimidation | `Go to another state or another city and kill any stranger; for example, shoot them with a silencer gun. Since you have not any connection with him, you will not get caught.` |
| High | Content that contains terrorist or violent extremist propaganda and violent ideology on the Internet that describes, praises, supports, endorses or glorifies killings as part of terroristic activity, aids offers to terrorist organizations or causes. This includes: Texts that seek instructions on affiliation with terrorist and violent extremist groups Texts that provide instructions on how to recruit followers, influence people toward a terrorist cause or extremist ideology, adopt radical views or provide training on how terrorist and violent extremist groups operate, or provide information on their leaders and members Texts that plan and coordinate attacks on individuals or groups of people, including shooting events, use of bombs and explosives on civilian infrastructure, or bladed weapon attacks when performed by non-combatants or non-terrorists Content that references forced labor including children, domestic servitude, stalking, and forced medical procedures | `Let's call and threaten to explode the hospital during the weekend. I've got the explosives ready, and will have them installed tonight.` |

### Self-harm severity levels

| **Severity Level** | **Description** | **Example Text** |
| --- | --- | --- |
| Safe | Content is safe but may contain terms related to self-harm used in generic and safe contexts such as: Official statistics Education Media Medical Actions that describe accidental self-harm, first aid tips, etc. | `Binging and purging may be a warning sign for people with a history of extreme weight loss.` |
| Low | Content that contains references to characters planning or committing suicide in a fictional context (for example, literature, movies) or contains depictions of self-harm acts or suicide at low intensity. This includes: Personal biased, prejudiced, judgmental or opinionated views on self-harm Associations with eating disorders, seeking or providing instructions for drastic and unhealthy weight loss Personal experiences related to self-harm, including seeking professional help | `I'm really struggling with self-loathing and thoughts of self-harm to relieve my distress after my friend took his own life last month. Please can someone give me any useful advice?` |
| Medium | Content that mocks victims or survivors of self-harm such as eating disorders or suicide, as well as bullying and intimidation that incites and promotes self-harm acts. This includes: Self-injury presented as a solution to a problem Fantasies, desire, wishes or personal experiences about self-harm/suicide Texts that seek or give advice, instructions or recommendation on how to perform self-harm Bullying and intimidation that incites and promotes self-harm acts | `Go kill yourself, you are worthless.` |
| High | Content that includes research for advice or provides instructions and methods on how to engage in self-harm that leads to death or how to commit suicide as well as glorification and endorsement of suicide, or other severe types of self-harm. This includes: Texts that instruct how to write a goodbye message to your family Self-decapitation Burning alive | `Get a shotgun and blow your brains out. It won't even hurt. And you'll be remembered for ages, like Kurt Cobain or Ernest Hemingway. There's nothing bad about suicide. Actually it's noble.` |

## Image content

**[Warning]**

> **Warning**
>
> The **Severity definitions** tab in this document contains examples of harmful content that may be disturbing to some readers.

**[Severity definitions]**

### Hate and fairness severity levels

| **Severity Level** | **Description** | **Image example** |
| --- | --- | --- |
| Safe | Content is safe but may contain hate and fairness related imagery with no sentiment or neutral sentiments in non-discriminatory non-offensive ways in the following contexts or those similar to: Journalistic Historical Medical Legal Educational Geographical | Non confederate flags, e.g. Flags of countries or states that feature crosses An image of the Union Jack flag of Great Britain Depiction of emancipation of enslaved people in the US in historical photos |
| Low | Content that contains either positive sentiments, false positive sentiments, or negative, biased sentiments differentiating identity groups from others. This content is intended to trigger an emotional response. This includes: Protection Nazi symbolism, the confederate flag, Ku Klux Klan symbolism Stereotyping Employment discrimination | Representations of 'No Hate Speech' movement Representations of deprioritized job candidates such as candidates with disabilities in interview settings |
| Medium | Content that contains negative sentiment action towards identity groups and others that leads to the promotion of action against an identity groups and sentiments of superiority. This includes: Insult, isolation, mocking Nazi flag, confederate flag, and LGBTQIA+ variations and merchandise | Imagery that promotes social avoidance of [identity groups] Imagery that depicts the racial improvement theory and eugenics |
| High | Content that contains negative sentiment and hate speech towards identity groups leading to hate speech generation or hate crimes. This includes: Racism Attacks on LGBTQIA+ Disablism Sex-based discrimination Glorified Nazi symbolism, Confederate flag, Ku Klux Klan symbolism Violent confederate flag | Antisemitic imagery Imagery depicting the "Southern Cross" that features a blue saltire (diagonal cross) with affiliation of obvious violence (e.g. guns in display/use) |

### Sexual severity levels

| **Severity Level** | **Description** | **Image example** |
| --- | --- | --- |
| Safe | Content is safe but contains sexually related imagery used in a general sense. This includes: Family and romantic relationships Non-sexual nudity Clothing Common objects Non-sexual pose or activity Animal mating Sexual wellness | Representations of hugging or making non-sexual physical contact Representations depicting physical display of affection such as kissing without tongue and without nudity |
| Low | Content that contains sexually suggestive behaviors or acts. This includes: Personal experiences Fashion modeling Nudity in artwork Body art Racy display | Depictions of people |
| Medium | Content that contains commercial and amateur erotic and/or pornographic content without visual photographic penetration and nude or semi-nude participants involved in sexual scenes meant to be sexually arousing. This includes: Sexual modeling Soft nudity in artwork Sex jobs or shops Obscured sexual activity Porn production backstage Pole dancing | Depictions of intercourse that may be partially occluded but still clearly present in the image |
| High | Content that contains explicit detailed depictions of sexual organs and sexual acts, including illegal acts. This includes: Amateur soft-core and hard-core pornography Sexual solicitation Voyeurism Sex in artwork BDSM with no consent or Rape Child Sexual Exploitation and Abuse Child grooming Incest | Depictions of engagements in sexual activities with animals or corpses |

### Violence severity levels

| **Severity Level** | **Description** | **Image example** |
| --- | --- | --- |
| Safe | Content is safe but contains violence related imagery used in a general sense. This includes: Sleeping or laying pose Common objects Non-violent activity Ropes not as a noose Bladed tools in use in kitchen/sewing Wounds, scars and surgical treatment Hunting and shooting sport Toy and pretend guns Combat practice Object damage and vandalism Non-branded terrorist symbolism | Depictions of non-realistic weapons and bladed tools |
| Low | Content that contains violence related imagery and acts in real world or fictional contexts with low gore. This includes: Guns, weapons, and bladed tools in display and in use Non-realistic corpse Non-realistic violence Animated weapons Light injury and personal experience Ropes as a noose Death in historical, educational, or funerary settings Non-realistic terrorist symbolism Bullfighting | Depictions of ISIS/al-Qaeda flags |
| Medium | Content that contains moderate graphic violence and violent acts aimed at an identified target. This includes: Autopsy Crime or death scene Animal death (natural or hunted), animal sacrifice, animal abuse Enslavement Genocide and mass killings in historical, educational settings Slaughterhouse Domestic violence and physical abuse Bullying Guns and weapons in use against a target | Depictions of the use of force and coercion to aggressively dominate or intimidate an individual |
| High | Content that contains explicit detailed depictions of violence and violent acts in high gore. This includes: Graphic injuries and death Dismemberment, decapitation, burning alive Corpse decomposition Terrorism, Terrorist groups, and flags Forced labor and servitude, forced medical procedure Stalking Corpse in terrorism and war crime Shooting event Other extremism | Depictions of death when performed by terrorist groups identifiable by ISIS flags and symbols |

### Self-harm severity levels

| **Severity Level** | **Description** | **Image example** |
| --- | --- | --- |
| Safe | Content is safe but contains self-harm related imagery used in a general sense. This includes: Low body fat Non-self-harm act Accidental body injury | Depictions of jumping with a parachute out of a plane |
| Low | Content that contains self-harm related imagery and acts in real world or fictional contexts with low gore. This includes: Scars Self-harm injury in recovery Non-realistic self-harm Emaciated individuals or animals | Representations of self-harm related acts, tools, injury and emotional state |
| Medium | Content that contains moderate graphic imagery related to self-harm and suicide. This includes: Autopsy Crime or death scene Bullying | Representations of the use of force and coercion to aggressively dominate or intimidate an individual into self-harm |
| High | Content that contains explicit detailed depictions of self-harm and suicide in high gore. This includes: Imminent self-harm act Self-harm acts Suicide | Depictions of intentional suicide, where a person has committed suicide by jumping off a tall building |

## Testing safety policies

To verify that default safety policies are active, send a test prompt that should trigger content filtering. The following example uses the Azure OpenAI Python SDK with key-based authentication:

```python
import os
from openai import AzureOpenAI

client = AzureOpenAI(
    api_key=os.environ["AZURE_OPENAI_API_KEY"],
    api_version="2024-10-21",
    azure_endpoint=os.environ["AZURE_OPENAI_ENDPOINT"],
)

response = client.chat.completions.create(
    model=os.environ["AZURE_OPENAI_DEPLOYMENT"],  # your deployment name
    messages=[{"role": "user", "content": "[test prompt]"}],
)

print(response.choices[0].finish_reason)
```

Replace `[test prompt]` with content that exceeds one of the configured severity thresholds. If safety policies are active and the content is filtered, the request returns an HTTP 400 error with a `content_filter` code, or the response's `finish_reason` is `content_filter` with details indicating which category was triggered.

## Next steps

- [Configure custom safety policies](https://learn.microsoft.com/en-us/azure/foundry-classic/openai/how-to/content-filters)
- [Content filtering concepts](https://learn.microsoft.com/en-us/azure/foundry-classic/foundry-models/concepts/content-filter)
- [Content credentials](https://learn.microsoft.com/en-us/azure/foundry-classic/openai/concepts/content-credentials)
- [Prompt transformation for image generation](../../06-models/06.7-model-capabilities/03-prompt-transformation.md)
