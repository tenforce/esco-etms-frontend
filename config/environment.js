/* jshint node: true */

module.exports = function(environment) {
  var ENV = {
    modulePrefix: 'etms-frontend',
    environment: environment,
    baseURL: '/esco/etms',
    locationType: 'auto',
    contentSecurityPolicy: {
      'default-src': "'none'",
      'script-src': "'self'",
      'font-src': "'self'",
      'connect-src': "'self' *",
      'img-src': "'self'",
      'style-src': "'self' 'unsafe-inline' *",
      'media-src': "'self'"
    },
    EmberENV: {
      FEATURES: {
        // Here you can enable experimental features on an ember canary build
        // e.g. 'with-controller': true
      }
    },
    filters: {
      inStatus: {
        id: "2c4cfa3d-7c56-4873-b098-fdd9118448a6",
        variables: ['status']
      }
    },
    // list of statuses, array because the order is important
    statuses: [{
      id: "all",
      name: "All",
      explained: "Show concept in any status"
    }, {
      id: "draft",
      name: "Draft",
      explained: "This concept was recently added, but not reviewed, translated or published."
    }, {
      id: "ready for publication",
      name: "Ready for publication",
      explained: "This concept was reviewed and ready to be published in the next publication."
    }, {
      id: "published",
      name: "Published",
      explained: "This concept was published in the latest publication."
    }, {
      id: "ready for deprecation",
      name: "Ready for deprecation",
      explained: "This concept is ready to be deprecated in the next publication."
    }, {
      id: "deprecated",
      name: "Deprecated",
      explained: "This concept was deprecated in one of the previous publications."
    }, {
      id: "deleted",
      name: "Deleted",
      explained: "This concept was deleted."
    }, {
      id: "edited",
      name: "Edited",
      explained: "This concept was modified since the last publication."
    }],

    APP: {
      // Here you can pass flags/options to your application instance
      // when it is created
    },
    // basic URIS that define the relationship between a skill and a concept
    relationshipTypes: {
      KNOWLEDGE_IRI: "http://data.europa.eu/esco/skill-type/knowledge",
      SKILL_IRI: "http://data.europa.eu/esco/skill-type/skill",
      OPTIONAL_SKILL_IRI: "http://data.europa.eu/esco/relationship-type/optional-skill",
      ESSENTIAL_SKILL_IRI: "http://data.europa.eu/esco/relationship-type/essential-skill",
      OCCUPATION_IRI: "http://data.europa.eu/esco/model#Occupation",
      OCCUPATION_TYPE_IRI: "http://data.europa.eu/esco/model#Occupation",
      SKILL_TYPE_IRI: "http://data.europa.eu/esco/model#Skill"
    },
    creationConceptOptions: {
      occupation: {
        label: 'Occupation',
        types: [
          'http://www.w3.org/2004/02/skos/core#Concept',
          'http://data.europa.eu/esco/model#MemberConcept',
          'http://data.europa.eu/esco/model#Occupation'
        ],
        skillType: null,
        skillTypeConceptUuid: null,
        regulatedConceptUuid: "a4b88a72-dd74-4936-81c5-950624016330",
        conceptScheme: "occupationScheme"
      },
      skill: {
        label: 'Skill',
        types: [
          'http://www.w3.org/2004/02/skos/core#Concept',
          'http://data.europa.eu/esco/model#MemberConcept',
          'http://data.europa.eu/esco/model#Skill'
        ],
        skillType: ["http://data.europa.eu/esco/skill-type/skill"],
        skillTypeConceptUuid: "26FB9006-20ED-11E7-AFF4-F6BFA3A88E4A",
        regulatedConceptUuid: null,
        conceptScheme: "skillScheme"
      },
      knowledge: {
        label: 'Knowledge',
        types: [
          'http://www.w3.org/2004/02/skos/core#Concept',
          'http://data.europa.eu/esco/model#MemberConcept',
          'http://data.europa.eu/esco/model#Skill'
        ],
        skillType: ["http://data.europa.eu/esco/skill-type/knowledge"],
        skillTypeConceptUuid: "26FB8FDE-20ED-11E7-AFF4-F6BFA3A88E4A",
        regulatedConceptUuid: null,
        conceptScheme: "skillScheme"
      }
    },
    validationTimeOut: 60 ,
    etms: {
      occupationScheme: '6b73f82c-2543-4a72-a86d-e988869df5ca',
      instanceTitle: 'ETMS Platform Demo',
      skillScheme: 'c61aced6-0285-4da5-aa9e-ef09ba364f6e',
      skillABCScheme: '046d8963-cafa-4b6a-9f62-c76c5ac784cb',
      naceScheme: '532c2193-35c3-494f-865a-fd7168e31436',
      iscoScheme: '16130956-533c-11e6-89a4-a439968efbe3',
      skillTypeScheme: 'CAFFFA18-20EB-11E7-AFF4-F6BFA3A88E4A',
      skillReuseLevelScheme: '73965DF2-20E7-11E7-AFF4-F6BFA3A88E4A',
      // skillScheme: '046d8963-cafa-4b6a-9f62-c76c5ac784cb',
      defaultLanguage: 'en',
      // disableTaxonomyChange: true,
      disableTaxonomyChange: false,
      // tooltipTaxonomyChange: "Switch taxonomies disabled, Skills are being implemented"
      tooltipTaxonomyChange: "Click to switch between pillars"
    }
  };

  if (environment === 'development') {
    ENV.baseURL = '/';
    locationType= 'auto';
    // ENV.APP.LOG_RESOLVER = true;
    // ENV.APP.LOG_ACTIVE_GENERATION = true;
    // ENV.APP.LOG_TRANSITIONS = true;
    // ENV.APP.LOG_TRANSITIONS_INTERNAL = true;
    // ENV.APP.LOG_VIEW_LOOKUPS = true;
  }

  if (environment === 'test') {
    // Testem prefers this...
    ENV.baseURL = '/';
    ENV.locationType = 'none';

    // keep test console output quieter
    ENV.APP.LOG_ACTIVE_GENERATION = false;
    ENV.APP.LOG_VIEW_LOOKUPS = false;

    ENV.APP.rootElement = '#ember-testing';
  }

  if (environment === 'production') {

  }
  ENV['ember-simple-auth'] = {
    authenticationRoute: 'sign-in',
    routeAfterAuthentication: 'index'
  };

  return ENV;
};
