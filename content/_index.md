---
# Leave the homepage title empty to use the site title
title: ''
date: 2022-10-24
type: landing

sections:
  - block: about.biography
    id: about
    content:
      title: Biography
      # Choose a user profile to display (a folder name within `content/authors/`)
      username: admin
  - block: markdown
    content:
      title: Research
      text: |-
        My research focuses on computational approaches to understanding personality pathology, particularly Borderline Personality Disorder (BPD). I use advanced statistical methods and multimodal data analysis to investigate the developmental trajectories and neural mechanisms underlying BPD symptoms.

        ## Current Research Areas

        **Computational Psychiatry & BPD**  
        Developing computational models to understand the cognitive and emotional processes in borderline personality disorder, with a focus on interpersonal dysfunction and emotion dysregulation.

        **Developmental Cognitive Neuroscience**  
        Investigating how personality pathology emerges across development using longitudinal neuroimaging and behavioral data.

        **Psychometrics & Quantitative Methods**  
        Advancing measurement approaches for personality pathology and developing novel statistical methods for analyzing complex psychological data.

        **Multimodal Data Analysis**  
        Integrating neuroimaging, behavioral, and ecological momentary assessment data to provide comprehensive models of personality functioning.
    design:
      columns: '2'
  - block: collection
    id: publications
    content:
      title: Publications
      subtitle: ''
      text: |-
        {{% callout note %}}
        PDFs available upon request via [email](mailto:natehall@unc.edu).
        {{% /callout %}}
      filters:
        folders:
          - publication
        exclude_featured: false
    design:
      columns: '2'
      view: citation
  - block: collection
    id: posts
    content:
      title: Posts
      subtitle: ''
      text: |-
        Occasional thoughts on research, methods, and life in academia.
      count: 5
      filters:
        folders:
          - post
        author: ""
        category: ""
        tag: ""
        exclude_featured: false
        exclude_future: false
        exclude_past: false
        publication_type: ""
      offset: 0
      order: desc
    design:
      view: compact
      columns: '2'
  - block: markdown
    content:
      title: CV
      text: |-
        **[Download my full CV (PDF)](/uploads/cv.pdf)**
        
        For a comprehensive overview of my academic background, research experience, publications, and professional activities.
    design:
      columns: '1'
  - block: markdown
    content:
      title: Why I am not a Clinical Psychologist
      text: |-
        This is a question I get asked frequently, so I thought I'd address it here. While I completed substantial clinical training during my graduate program, including coursework in assessment, psychotherapy, and psychopathology, I ultimately decided not to pursue clinical internship or licensure as a clinical psychologist.

        My decision was driven by my passion for research and discovery rather than direct clinical practice. I found myself most energized by questions about the underlying mechanisms of personality pathology, the development of new measurement approaches, and the application of computational methods to understand psychological phenomena.

        The clinical training I received has been invaluable to my research - it provides me with a deep understanding of the lived experience of mental health conditions and ensures that my research questions are clinically meaningful. However, my calling lies in contributing to our scientific understanding of these conditions rather than providing direct treatment.

        I have tremendous respect for clinical psychologists and the vital work they do. My path simply led me toward research, where I hope to contribute to better understanding and ultimately better treatments for personality pathology.
    design:
      columns: '2'
---
