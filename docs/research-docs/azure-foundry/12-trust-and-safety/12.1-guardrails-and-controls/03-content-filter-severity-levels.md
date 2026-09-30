# Harm categories and severity levels in Microsoft Foundry

| Field | Value |
| --- | --- |
| **Document Title** | Harm categories and severity levels in Microsoft Foundry |
| **Document Location** | `docs/research-docs/azure-foundry/12-trust-and-safety/12.1-guardrails-and-controls/03-content-filter-severity-levels.md` |
| **Document Description** | Reference copy of the Microsoft Learn article "Harm categories and severity levels in Microsoft Foundry". Learn about the harm categories and severity levels used by the content safety system in Microsoft Foundry to detect and filter harmful content. |
| **Version** | 1.1 |
| **Last Updated On** | 2026-09-30 |

> **Source:** [Microsoft Learn](https://learn.microsoft.com/en-us/azure/foundry/openai/concepts/content-filter-severity-levels). Article date: 2026-09-08. Page updated: 2026-09-18. Retrieved: 2026-09-29. Navigation: Trust and safety > Guardrails and controls > Risks > Harm categories and severity levels.
>
> **Reference copy.** Microsoft owns this content. It was converted to Markdown and is not rewritten to the repository writing style. Links to other Foundry articles point to the local copies where they exist. Check the source for the current version.

Guardrails, powered by Azure AI Content Safety, ensure that AI-generated outputs align with ethical guidelines and safety standards. The content filtering system classifies harmful content into four categories — hate, sexual, violence, and self-harm - for both text and image content. Use these categories to configure levels for guardrail controls that detect and mitigate risks associated with harmful content in your model deployments and agents.

The content safety system uses neural multiclass classification models to detect and filter harmful content for both text and image. Content detected at the "safe" severity level is labeled in annotations but isn't subject to filtering and isn't configurable.

> **Note**
>
> The text content safety models for the hate, sexual, violence, and self-harm categories are trained and tested on the following languages: English, German, Japanese, Spanish, French, Italian, Portuguese, and Chinese. The service can work in many other languages, but detection accuracy and false positive rates may vary. In call cases, conduct thorough testing to validate performance meets your requirements.

## Harm category descriptions

The following table summarizes the harm categories supported:

| Category | Description |
| --- | --- |
| **Hate and Fairness** | Hate and fairness-related harms refer to any content that attacks or uses discriminatory language with reference to a person or identity group based on certain differentiating attributes of these groups. This category includes, but isn't limited to: • Race, ethnicity, nationality • Gender identity groups and expression • Sexual orientation • Religion • Personal appearance and body size • Disability status • Harassment and bullying |
| **Sexual** | Sexual describes language related to anatomical organs and genitals, romantic relationships and sexual acts, acts portrayed in erotic or affectionate terms, including those portrayed as an assault or a forced sexual violent act against one's will. This category includes but isn't limited to: • Vulgar content • Prostitution • Nudity and pornography • Abuse • Child exploitation, child abuse, child grooming |
| **Violence** | Violence describes language related to physical actions intended to hurt, injure, damage, or kill someone or something; describes weapons, guns, and related entities. This category includes, but isn't limited to: • Weapons • Bullying and intimidation • Terrorist and violent extremism • Stalking |
| **Self-Harm** | Self-harm describes language related to physical actions intended to purposely hurt, injure, damage one's body or kill oneself. This category includes, but isn't limited to: • Eating disorders • Bullying and intimidation |
| **Task Adherence** | Helps ensure AI Agents consistently behave in alignment with user instructions and task objectives. It identifies discrepancies, such as misaligned tool invocations, improper tool input or output relative to user intent, and inconsistencies between responses and customer input. |

## Severity levels for guardrails

Guardrails classifies harmful content into four severity levels:

| Severity level | Description |
| --- | --- |
| **Safe** | No harmful material detected. Annotated but never filtered. |
| **Low** | Mild harmful material. Includes prejudiced views, mild depictions in fictional contexts, or personal experiences. |
| **Medium** | Moderate harmful material. Includes graphic depictions, bullying, or content that promotes harmful acts. |
| **High** | Severe harmful material. Includes extremist content, explicit depictions, or content that endorses serious harm. |

### How severity levels map to guardrail configuration

When you configure a guardrail control for a harm category, you set a severity threshold that determines which content is flagged:

| Threshold setting | Behavior |
| --- | --- |
| **Off** | Detection is disabled for this category. No content is flagged or blocked. |
| **Low** | Flags content at low severity and higher. Least restrictive setting. |
| **Medium** | Flags content at medium severity and higher. |
| **High** | Flags only the most severe content. Most restrictive setting. |

Content at the **Safe** level is always annotated but never blocked, regardless of threshold setting.

## Severity levels for Azure AI Content Safety

Every harm category the service applies also comes with a severity level rating. The severity level indicates the severity of the consequences of showing the flagged content.

**Text**: The current version of the text model supports the full 0-7 severity scale. The classifier detects among all severities along this scale. If you specify, it can return severities in the trimmed scale of 0, 2, 4, and 6; each two adjacent levels are mapped to a single level.

- `[0,1]` -> `0`
- `[2,3]` -> `2`
- `[4,5]` -> `4`
- `[6,7]` -> `6`

**Image**: The current version of the image model supports the trimmed version of the full 0-7 severity scale. The classifier only returns severities 0, 2, 4, and 6.

- `0`
- `2`
- `4`
- `6`

**Image with text**: The current version of the multimodal model supports the full 0-7 severity scale. The classifier detects among all severities along this scale. If you specify, it can return severities in the trimmed scale of 0, 2, 4, and 6; each two adjacent levels are mapped to a single level.

- `[0,1]` -> `0`
- `[2,3]` -> `2`
- `[4,5]` -> `4`
- `[6,7]` -> `6`

## Severity definitions

### Detailed severity definitions for text in Guardrails

The following tables provide detailed descriptions and examples for each severity level within each harm category for text content in Guardrails. Select the **Severity definitions** tab to view examples.

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

### Detailed severity definitions for text in Azure AI Content Safety

The following tables provide detailed descriptions and examples for each severity level within each harm category for text content in Azure AI Content Safety. Select the **Severity definitions** tab to view examples.

## Full-scale text content

**[Warning]**

> **Warning**
>
> The **Severity definitions** tab in this document contains examples of harmful content that may be disturbing to some readers.

**[Severity definitions]**

### Hate and fairness severity levels

| **Severity Level** | **Description** | **Example Text** |
| --- | --- | --- |
| Level 0 | Content that contains hate and fairness related terms used in the general sense and is appropriate for all target audiences, including children. This includes: General, pejorative language expressing dislike against identity groups General mentions of identity group attributes, such as race, ethnicity, religion, etc. in historical, geographical, medical, and other similar contexts with no sentiment General terms that have no racial undertones of offensive intent outside of context | `I hate cats.` |
| Level 1 | Content that contains hate and fairness related terms used in the general sense but may acquire a different meaning based on context and does not differentiate between identity groups and others in a biased or negative way. This includes: Official statistics, legislation, or documentation News/media coverage Educational resources meant to raise awareness of diversity/tackling hate speech Skin-whitening products and treatment ads Mentions of Indo-Eurasian swastika, the confederate flag, non-KKK groups that have visual resemblance with KKK | `Black people should not be killed by police or mistreated just because of their skin color.` |
| Level 2 | Content that contains positive characterization or protection of the identity groups that trigger a favorable emotional response. This includes: Slurs spelled out fully in research papers, dictionaries, or media with direct quotes Statements by a speaker who belongs to an identity group without intent to target the same identity group Curse words, profanity, and verbal insults that do not target an identity group General hate speech that targets unidentified individuals/groups without targeting an identity group User intent of creating a blocklist of offensive terms Representations of Nazi Germany, Hitler, the confederate flag, and Ku Klux Klan symbolism in movies, video games, costumes, toys, reenactments, or online slang | `I hate you.` |
| Level 3 | Content that contains prejudiced, judgmental, stereotypical characterization or negative sentiment. This includes: Opinion based on stereotyping or negative sentiment Expresses prejudiced, judgmental, or opinionated views Negative or positive comparisons differentiating between identity groups and others. Mentions in fictional worlds Employment discrimination in job postings Historical facts and artifacts related to Nazi Germany, the Confederate flag during the US Civil War, or the Ku Klux Klan | `I don't like [identity group] because they are all so aggressive. They attacked us over and over again for no reason at all.` |
| Level 4 | Content that contains direct verbal sentiment-motivated insults, negative comments, and racial slurs used as descriptions targeting identity groups with the intention to hurt individuals based on their attributes. This includes: References used to target one's race, skin color Promotion of social avoidance and isolation Mocking and imitating attributes of identity groups | `All [identity group] are ugly.` |
| Level 5 | Content that contains dehumanization or derogation of individuals or groups that furthers negative sentiment through dehumanization, violence, denial of events, bullying, or intimidation behaviors. This includes: Texts that deny historical, well-documented, and violent events such as the Holocaust Texts that describe individuals or groups as physically or mentally inferior based on membership in an identity group Texts that question, deny, or demean identity group existence Enforcement of desired/expected attributes Eugenics and 'racial improvement' theories that target identity groups Modern merchandise that contains Nazi, the confederate flag, or KKK symbols | `The [real world event] is a fraud. What we've discovered is that sources have been lying about the number of victims. Here is proof.` |
| Level 6 | Content based on negative sentiment and hate speech towards identity groups. By referring to group characteristics that differentiate the identity group and others and appealing to take action against identity groups based on their attributes. This can include: Hate speech propaganda that can be perceived as a direct threat to or a call for violence towards an identity group Incendiary, offensive, and vulgar hate speech Texts that allegedly claim one group's superiority over those with the attributes of the identity groups to justify discrimination, segregation, or exclusion Texts describing joy regarding a violent event that targeted an identity group | `Send [identity group] back to the gas chambers.` |
| Level 7 | Content based on negative sentiment, displaying intent of hate crime and stalking, triggering a hostile emotional response and differentiating identity groups and others leading to crime. This includes: Hate crime preparation, praise, and glorification of violence against an identity group Texts that contain supremacist groups' recruitment material Texts meant to radicalize and encourage hate speech against an identity group | `Millions of [identity group] were wiped out because they were the inferior race. Murdering them continues to be right and honorable because…` |

### Sexual severity levels

| **Severity Level** | **Description** | **Example Text** |
| --- | --- | --- |
| Level 0 | Content that contains sexually related terms used in general sense that is harmless for all target audiences, including children. Mentions of family relations Content that is harmless for all target audiences, including children | `The sports bra and yoga pants were too tight for comfort.` |
| Level 1 | Content that contains sexually related terms used in general sense but may acquire a different meaning based on context. This includes: Official statistics and documentation on sex-related topics News/media coverage Anatomical terms, sexual anatomy, and medical treatment Educational resources on sex, sexual wellness, awareness, etc. Mentions of biological sex or descriptions of sexual reproduction Texts that describe romantic relationships in non-graphic terms | `Fewer young adults are having sex than in previous generations.` |
| Level 2 | Content that contains sexually related terms in fictional or real world experiences that are not extremely graphic. This includes: Mentions of literary/artistic texts, movies, sculptures, etc. that contain limited dirty talk or brief non-explicit nudity scenes Personal experiences related to sex in general, sexual problems and traumas, sharing of coping mechanisms and resources to address such issues User intent of creating a blocklist for sexual content Mentions of sexual acts and nudity with light core | `My husband and I introduced a vibrator to our sex life and it has really made a difference.` |
| Level 3 | Content with sexually related terms in cases that contain some graphic content, opinions expressing biased, prejudiced, judgmental or opinionated views on sex related issues. This includes: Personal past or present sexual experiences with some graphic content | `We made out for a while, and he started to feel me up. I felt a bulge in his pants.` |
| Level 4 | Content describing sexual fantasies, professional sex industry and advertisements, and sexualized animal reproduction. This includes: Fantasies of sex of different types, including imagining real or fictional nudity Professional sex industry without descriptions of sex scenes Advertisements for condoms, lubricants, sex toys, clothing, etc.. Descriptions of sexual reproduction between animals or animal-like characters with some graphic content Mentions of sexual acts and nudity with soft core | `I got into BDSM because I had some friends into the lifestyle and it piqued my interest. I like using silk, scarves, collars, and bondage…` |
| Level 5 | Content describing erotic shows or experiences as personal experience, BDSM with clear consent, and erotic stories and websites. This includes: Mentions of sexual, erotic or tantric massages, strip clubs, erotic shows as personal experience (not as a professional service) Personal experiences and descriptions related to BDSM attributes and practices in general or situations with clear content to BDSM practice Mentions of non-commercial erotic content related to sexual desire or pleasure | `We both climaxed at the same time.` |
| Level 6 | Content describing solicitation of sexual commercial services, containing detailed descriptions of sexual activity, violent sexual abuse and rape, and non-consensual power exchanges, abuse, and voyeurism. This includes: Mentions of stimulation of genitals with hands or other objects, masturbation, etc. Fetish or crude content involving bodily fluids, situations of sex control, or BDSM activities without clear consent Texts that describe sexual violence, sexual assault, rape or abuse in graphic details Texts that attribute positive qualities to sexual assault Texts that seek or provide instructions to perform sexual assault Acts of blackmail and threats to reveal unconsented sexual images or videos previously recorded | `I love forced sex, it's so much hotter.` |
| Level 7 | Content used to promote, endorse, glorify extreme forms of sexual enslavement. Content that is extreme or illegal. This includes: Sex with animals, corpses, etc. Paedophilia Seeking or providing instructions on child grooming Explicit or potential references to incest Human sex trafficking recruitment | `I was abused as a child by my uncle and I liked it. Nowadays, I make money by producing child pornography with my neighbor’s 6 year old son.` |

### Violence severity levels

| **Severity Level** | **Description** | **Example Text** |
| --- | --- | --- |
| Level 0 | Content that contains non-violent actions or violence-related terms used in a general sense that is harmless for all target audiences, including children. This includes: Common objects when not used as weapons Toy guns, non-realistic or pretend guns Mentions of ropes when not used as a noose | `According to our child and parent testers, here are the best long-range soakers for soft blasters for toddlers suitable for epic water battles.` |
| Level 1 | Content that contains violence-related terms or acts used in a general sense but may acquire a different meaning based on context. This includes: Subsets of texts that contain descriptions of violent acts, where the contextualization of the full text does not possess violent intent Official statistics and documentation on guns, weapons, domestic violence, warfare, military, etc. Educational resources related to violence News/media coverage Medical terms and content Hunting or shooting sport and guns technical specifications Combat practice Counter-terrorism and terrorist symbols unrelated to ISIS/al-Qaeda | `Carnivores such as lions and tigers are prone to killing one another. Death occurs at the paws, claws, jaws, or tusks that might fatally gore one another during fights.` |
| Level 2 | Content that contains violence-related terms or acts in fictional or real world experiences that are not extremely graphic and without glorification or endorsement of malintent. This includes: First, second, and third person narration in video games, literary/artistic texts that depict violent or graphic scenes Gaming tips and recommendations Personal experiences in which an individual describes how they were exposed to some type of violence Mentions of ropes when used as a noose without human subjects present or not related to the noose User intent is to create a blocklist with violent content | `Physical punishment is a way to correct bad behavior and doesn’t cause harm to children.` |
| Level 3 | Content with violence-related terms or acts in cases that contain some graphic content, opinions expressing biased, prejudiced, judgmental or opinionated views on violence. This includes: Allowing cruelty for some animals Texts claiming positive impact of some types of violence | `Some people just need to be slapped.` |
| Level 4 | Content describing ungrounded rationale for why victims are being physically abused, unfounded attribution of positive qualities of abusers, threats of violent acts and fantasies relating to how to harm another person, and medium gore. This includes: Texts that put the victim at fault or depict perpetrators in a positive light Graphic descriptions of violence and death with medium gore An autopsy report, a forensic investigation, crime or death scene Meat and poultry facilities, and religious animal sacrifice References to historical or recent genocides and known shooting events with mass casualties without endorsement or glorification References to terrorist and violent extremist events without endorsement or glorification | `Victims of abuse deserve to be hit. They push and push until they get what they deserve.` |
| Level 5 | Content aiming to further violence, providing direct instructions on how to harm specific individuals or groups. This includes: Texts that incite physical violence against targeted individuals/groups Instructions on how to cause physical violence to individuals or abuse to animals Texts seeking advice on how to perform violent acts on animals, individuals, or groups Bullying and intimidation | `Go to another state or another city and kill any stranger; for example, shoot them with a silencer gun. Since you have not any connection with him, you will not get caught.` |
| Level 6 | Content describing extremist groups and terroristic organizations, mass killings and explicit physical damage in high gore, and promotion of terrorism and its propaganda. This includes: Official terrorist or extremist propaganda materials and violent ideology on the internet Inciting to take a violent action | `We must kill them all. God wills it, and society will be better for it.` |
| Level 7 | Content used to describe, praise, support, promote, endorse, glorify extreme forms of violence. Content that supports terroristic organizations and radicalizes, instructs, or trains. This includes: Forced labor including children, domestic servitude, or medical treatment Online terrorist and violent extremist propaganda materials that glorify killings as a part of terrorist activity and aid offers to terrorist organizations or causes Texts that seek instructions on affiliation with terrorist and violent extremist groups on how to recruit, influence, and train people towards the cause Illegal harassing behaviors such as stalking or unwanted surveillance Texts that plan and coordinate attacks on individuals or groups of people Texts that endorse, glorify, or provide instructions on cannibalism | `Let's call and threaten to explode the hospital during the weekend. I've got the explosives ready, and will have them installed tonight.` |

### Self-harm severity levels

| **Severity Level** | **Description** | **Example Text** |
| --- | --- | --- |
| Level 0 – Safe | Content that contains self-harm related terms used in a general sense that is harmless for all target audiences, including children. This includes: Mentions of body fat, fat mass index indicators by age and gender in health-related contexts | `I appreciate your hard work, but you don't need to keep killing yourself over this project.` |
| Level 1 | Content that contains self-harm related terms used in a general sense but may acquire a different meaning based on context. This includes: Official statistics and documentation on Non-Suicidal Self Injury (NSSI), suicide, etc. Educational resources related to self-harm News/media coverage Medical terms and content Actions that describe accidental self-harm, first aid tips, etc. | `Binging and purging may be a warning sign for people with a history of extreme weight loss.` |
| Level 2 | Content that contains self-harm related terms or acts in fictional or real world experiences that are not extremely graphic. This includes: Literary/artistic texts, movies, etc. depicting characters plotting or committing suicide, engaging in self-harm, or disordered eating with no glorification or endorsement Texts where self-harm acts or suicide is depicted with low gore User intent is to create blocklists of self-harm terms | `Oedipus stabbed his eyes in despair.` |
| Level 3 | Content with self-harm related terms or acts in cases that contain some graphic content, opinions expressing biased, prejudiced, judgmental or opinionated views on self-harm. This includes: Personal experiences related to self-harm, such as asking for help before hurting themselves or committing suicide | `I'm really struggling with self-loathing and thoughts of self-harm to relieve my distress after my friend took his own life last month. Please can someone give me any useful advice?` |
| Level 4 | Content that mocks victims or survivors of suicide or self-harm, unfounded attribution of positive qualities to self-harm, fantasies or wishes of self-harm, and contains explicitly graphic content involving death, autopsy, crime, or death scene. This includes: Self-injury presented as a solution to a problem, emotional distress, escape from pain/agony Texts where self-harm or suicide contains medium gore and descriptions of tools such as a knife, a pistol, etc. | `It's hilarious when [identity group] kill themselves.` |
| Level 5 | Content aiming to further promotion of self-harm, providing direct instructions on how to perform self-harm or bully a victim. This includes: Texts that seek advice or recommendations on how to perform self-harm acts except for suicide Texts that describe personal past and present experiences of self-harm that contains explicit details Bullying, intimidation, and pressuring that incites and promotes self-harm acts | `Go kill yourself, you are worthless.` |
| Level 6 | Content describing detailed and explicit instructions on how to commit suicide. This includes: Texts that instruct how to write a goodbye message to your family | `Here is a quick guide to do-it-yourself suicide. One method is asphyxia suicide by inhaling helium inside a plastic bag.` |
| Level 7 | Content used to endorse and glorify suicide or other severe acts of self-harm. This includes: Self-decapitation Burning alive | `Get a shotgun and blow your brains out. It won't even hurt. And you'll be remembered for ages, like Kurt Cobain or Ernest Hemingway. There's nothing bad about suicide. Actually it's noble.` |

### Detailed severity definitions for images in Guardrails and Azure AI Content Safety

The following tables provide detailed descriptions and examples for each severity level within each harm category for image content. Select the **Severity definitions** tab to view examples.

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

### Detailed severity definitions for multimodal in Azure AI Content Safety

The following tables provide detailed descriptions and examples for each severity level within each harm category for multimodal content. Select the **Severity definitions** tab to view examples.

## Multimodal (image with text) content

**[Warning]**

> **Warning**
>
> The **Severity definitions** tab in this document contains examples of harmful content that may be disturbing to some readers.

**[Severity definitions]**

### Hate and fairness severity levels

| **Severity Level** | **Description** | **Image example** |
| --- | --- | --- |
| Safe | Content is safe but may contain hate and fairness related text and visuals used in generic and safe contexts such as: Education Media Official statistics History Medicine Science Other similar contexts | Scenario: Image with text overlay Image: Benign photo of a person Text: `Attends rally wearing sneakers` |
| Low | Content that contains positive characterization or protection of the Identity groups, displays discrimination, stereotypes and prejudiced, judgmental, opinionated views or attitudes related to hate speech or targeting identity groups. This includes: Slurs in research papers, dictionaries, or media with a direct quote General hate speech that targets objects, individuals or groups Limited hate speech or depictions of negative sentiment in fictional contexts (for example, gaming, movies, literature) | Scenario: Image with text overlay Image: Benign photo of a person Text: `Everyone assumes that I got high grades in math because I’m Asian. I did.` Rationale: Implies racial stereotype. |
| Medium | Content that contains insults, bullying, intimidation, de-humanization or derogation of individuals or groups. This includes: Slurs in research papers, dictionaries, or media with a direct quote General hate speech that targets objects, individuals or groups Limited hate speech or depictions of negative sentiment in fictional contexts (for example, gaming, movies, literature) | Scenario: Image with text overlay Image: Benign photo of a person with Parkinsons Text: `This guy just Friended and Unfriended me 45 times in 15 seconds. Does anyone know him?` Rationale: Implies mockery due to disability |
| High | Content that contains hate speech as propaganda threatening or calling for violence against Identity groups, radicalizes, recruits or incites people to join extremist efforts or spread hate speech. This includes: Incendiary, offensive, and vulgar content targeting specific individuals or identity groups Claims of superiority to justify discrimination, segregation, or exclusion Any form of glorification of Nazi and SS symbolism, KKK and the confederate flag outside of historical, educational, or artistic settings Displays of hate crime preparation, praise and glorification of violence against Identity groups, or that praise, glorify, or endorse genocide | Scenario: Image and text interleaved `Never forget that everything [image of Adolf Hitler] did in Germany was legal.` |

### Sexual severity levels

| **Severity Level** | **Description** | **Image example** |
| --- | --- | --- |
| Safe | Content is safe but may contain sexually related terms or visuals used in generic and safe contexts such as: Education Media Official statistics History Medicine Science Mentions of family or romantic relations | Scenario: Image with text overlay Image: A skunk Text: `Looks aren’t everything, be careful who you marry, and check your mirrors too.` |
| Low | Content that expresses prejudiced, judgmental or opinionated views on sexually related topics or mentions sexually related terms in fictional or real-world experiences that are not extremely graphic. This includes: Mentions of sexual anatomy or sex scenes in fictional and artistic contexts Medical prescriptions and diagnosis Personal experiences, sexual problems and traumas with some graphic content including coping mechanisms and resources | Scenario: Image and text interleaved `I hope they debate social issues I want [image of a person cupping their ear, representing "to hear"] about how a representative wants to regulate female sexual organs.` |
| Medium | Content that describes sexual arousal and activity in explicit and graphic terms or visuals, including fantasies about sex and sexual abuse. This includes: Depictions of sexual stimulation and masturbation Pornography limited to business and prostitution, escort, etc. as careers without sex scenes Advertisement for adult products such as sex toys Personal experiences and descriptions related to sexual, erotic or tantric massages, strip clubs, erotic shows, BDSM attributes and practices | Scenario: Image and text interleaved `There is so much [image containing the phrase "Sex and Violence"] in that book it could use a warning label in the cover.` |
| High | Content describing solicitation of sexual commercial services, containing detailed descriptions of sexual activity, violent sexual abuse and rape, and non-consensual power exchanges, abuse, and voyeurism. This also includes content that is used to promote, endorse, or glorify extreme or illegal sexual acts. This includes: Any depiction of Child Sexual Abuse Material (CSAM) including any explicit or potential reference to underage sex Child grooming, child abuse, and other child exploitation Explicit or potential references to incest, zoophilia, necrophilia, etc. Human sex trafficking recruitment, including victim manipulation | Scenario: Image and text interleaved `Can too much [image of graphic pornography] actually kill you? Evidently not, because you are still with us.` |

### Violence severity levels

| **Severity Level** | **Description** | **Image example** |
| --- | --- | --- |
| Safe | Content is safe but may contain terms and visuals related to violence used in generic and safe contexts such as: Education Media Official statistics History Medicine Science Common objects when not used as weapons Hunting or shooting sport and guns technical specifications | Scenario: Image and text interleaved `[Image of lawnmower] can easily throw a [image of rock] to a distance well over 50 feet.` |
| Low | Content in fictional contexts (for example, gaming, literature, arts) that depict violent or graphic scenes without glorification, endorsement or malintent. This includes: Personal experiences of violence (without violent intent) Biased, prejudiced, judgmental, or opinionated views on violence Mentions of violent acts and death at low intensity | Scenario: Image with text overlay Image: Benign photo of a "nerdy" person Text: `Runs suicides at basketball practice. Dies.` Rationale: Implies exhaustion due to the lack of physical abilities of the person. |
| Medium | Content that contains graphic depictions of violence and death at medium intensity as well as fantasies about violent acts or threats. This includes: Content that puts the victim at fault or depicts perpetrators in a positive light Historical references to genocide and the Holocaust without endorsement or glorification References to known mass shootings without endorsement or glorification References to terrorist and violent extremist groups and events without endorsement or glorification Bullying and intimidation | Scenario: Image and text interleaved `She needs [image of a graphic that reads "to die"] already`. |
| High | Content that contains terrorist or violent extremist propaganda and violent ideology on the Internet that describes, praises, supports, endorses or glorifies killings as part of terroristic activity, aids offers to terrorist organizations or causes. This includes: Content that seeks instructions on affiliation with terrorist and violent extremist groups Content that provides instructions on how to recruit followers, influence people toward a terrorist cause or extremist ideology, adopt radical views or provide training on how terrorist and violent extremist groups operate, or provide information on their leaders and members Content that plans and coordinates attacks on individuals or groups of people, including shooting events, use of bombs and explosives on civilian infrastructure, or bladed weapon attacks when performed by non-combatants or non-terrorists Content that references forced labor including children, domestic servitude, stalking, and forced medical procedures | Scenario: Image and text interleaved `I can’t wait for this [image of ISIS kafir beheading].` |

### Self-harm severity levels

| **Severity Level** | **Description** | **Image example** |
| --- | --- | --- |
| Safe | Content is safe but may contain terms or visuals related to self-harm used in generic and safe contexts such as: Official statistics Education Media Medical Actions that describe accidental self-harm, first aid tips, etc. | Scenario: Image and text interleaved `How do I tie a [image of a rope]?` |
| Low | Content that contains references to characters planning or committing suicide in a fictional context (for example, literature, movies) or contains depictions of self-harm acts or suicide at low intensity. This includes: Personal biased, prejudiced, judgmental or opinionated views on self-harm Associations with eating disorders, seeking or providing instructions for drastic and unhealthy weight loss Personal experiences related to self-harm, including seeking professional help | Scenario: Image with text overlay Image: Kermit the frog Text: `Life ain’t no good for a frog. Even tried to Kermit suicide.` |
| Medium | Content that mocks victims or survivors of self-harm such as eating disorders or suicide, as well as bullying and intimidation that incites and promotes self-harm acts. This includes: Self-injury presented as a solution to a problem Fantasies, desire, wishes or personal experiences about self-harm/suicide Content that seeks or gives advice, instructions or recommendations on how to perform self-harm Bullying and intimidation that incites and promotes self-harm acts | Scenario: Image with text interleaved `I will [image of a knife] myself soon. But until then, how do I tame my pain?` |
| High | Content that includes research for advice or provides instructions and methods on how to engage in self-harm that leads to death or how to commit suicide as well as glorification and endorsement of suicide, or other severe types of self-harm. This includes: Content that instructs how to write a goodbye message to your family Self-decapitation Burning alive | Scenario: Image and text interleaved `Black Friday [image of self-harm with text "My self-harm cuts have nearly faded completely so they won’t scar"] and [image of a kitchen mixer] deals.` |

## Troubleshooting

### Understanding severity classifications

If content is classified at an unexpected severity level:

- Review the detailed severity definitions to understand the classification criteria.
- Check if context is missing that would change the interpretation (educational, historical, fictional).
- Verify the content language is in the supported list for best accuracy.
- In Guardrails, use annotations to see all detected categories, not just filtered ones.

### Adjusting sensitivity

If you see too many false positives or negatives:

- Review your threshold settings.
- Consider whether the content type (educational, medical, creative) requires a custom content policy.
- For Guardrails supported use cases, request a custom content filter configuration.
