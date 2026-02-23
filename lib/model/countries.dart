// Mapa completo: código ISO → nome em português
const Map<String, String> countryNames = {
  'ad': 'Andorra', 'ae': 'Emirados Árabes', 'af': 'Afeganistão',
  'ag': 'Antígua e Barbuda', 'al': 'Albânia', 'am': 'Armênia',
  'ao': 'Angola', 'ar': 'Argentina', 'at': 'Áustria',
  'au': 'Austrália', 'az': 'Azerbaijão', 'ba': 'Bósnia e Herzegovina',
  'bb': 'Barbados', 'bd': 'Bangladesh', 'be': 'Bélgica',
  'bf': 'Burkina Faso', 'bg': 'Bulgária', 'bh': 'Bahrein',
  'bi': 'Burundi', 'bj': 'Benin', 'bn': 'Brunei',
  'bo': 'Bolívia', 'br': 'Brasil', 'bs': 'Bahamas',
  'bt': 'Butão', 'bw': 'Botswana', 'by': 'Bielorrússia',
  'bz': 'Belize', 'ca': 'Canadá', 'cd': 'Congo (RDC)',
  'cf': 'Rep. Centro-Africana', 'cg': 'Congo', 'ch': 'Suíça',
  'ci': 'Costa do Marfim', 'cl': 'Chile', 'cm': 'Camarões',
  'cn': 'China', 'cr': 'Costa Rica', 'cu': 'Cuba',
  'cv': 'Cabo Verde', 'cy': 'Chipre', 'cz': 'República Tcheca',
  'dj': 'Djibuti', 'dk': 'Dinamarca', 'dm': 'Dominica',
  'do': 'Rep. Dominicana', 'dz': 'Argélia', 'ec': 'Equador',
  'ee': 'Estônia', 'eg': 'Egito', 'er': 'Eritreia',
  'es': 'Espanha', 'et': 'Etiópia', 'fi': 'Finlândia',
  'fj': 'Fiji', 'ga': 'Gabão', 'gb': 'Reino Unido',
  'gd': 'Granada', 'ge': 'Geórgia', 'gh': 'Gana',
  'gm': 'Gâmbia', 'gn': 'Guiné', 'gq': 'Guiné Equatorial',
  'gr': 'Grécia', 'gt': 'Guatemala', 'gw': 'Guiné-Bissau',
  'gy': 'Guiana', 'hn': 'Honduras', 'hr': 'Croácia',
  'ht': 'Haiti', 'hu': 'Hungria', 'id': 'Indonésia',
  'ie': 'Irlanda', 'il': 'Israel', 'in': 'Índia',
  'iq': 'Iraque', 'ir': 'Irã', 'is': 'Islândia',
  'jm': 'Jamaica', 'jo': 'Jordânia', 'ke': 'Quênia',
  'kg': 'Quirguistão', 'kh': 'Camboja', 'ki': 'Kiribati',
  'km': 'Comores', 'kn': 'São Cristóvão e Nevis',
  'kp': 'Coreia do Norte', 'kr': 'Coreia do Sul',
  'kw': 'Kuwait', 'kz': 'Cazaquistão', 'la': 'Laos',
  'lb': 'Líbano', 'lc': 'Santa Lúcia', 'li': 'Liechtenstein',
  'lk': 'Sri Lanka', 'lr': 'Libéria', 'ls': 'Lesoto',
  'lt': 'Lituânia', 'lu': 'Luxemburgo', 'lv': 'Letônia',
  'ly': 'Líbia', 'ma': 'Marrocos', 'mc': 'Mônaco',
  'md': 'Moldávia', 'me': 'Montenegro', 'mg': 'Madagascar',
  'mh': 'Ilhas Marshall', 'mk': 'Macedônia do Norte',
  'ml': 'Mali', 'mm': 'Myanmar', 'mn': 'Mongólia',
  'mr': 'Mauritânia', 'mt': 'Malta', 'mu': 'Maurício',
  'mv': 'Maldivas', 'mw': 'Malaui', 'mx': 'México',
  'my': 'Malásia', 'mz': 'Moçambique', 'na': 'Namíbia',
  'ne': 'Níger', 'ng': 'Nigéria', 'ni': 'Nicarágua',
  'nl': 'Países Baixos', 'no': 'Noruega', 'np': 'Nepal',
  'nr': 'Nauru', 'nz': 'Nova Zelândia', 'om': 'Omã',
  'pa': 'Panamá', 'pe': 'Peru', 'pg': 'Papua Nova Guiné',
  'ph': 'Filipinas', 'pk': 'Paquistão', 'pl': 'Polônia',
  'pt': 'Portugal', 'pw': 'Palau', 'py': 'Paraguai',
  'qa': 'Catar', 'ro': 'Romênia', 'rs': 'Sérvia',
  'rw': 'Ruanda', 'sa': 'Arábia Saudita', 'sb': 'Ilhas Salomão',
  'sc': 'Seicheles', 'sd': 'Sudão', 'se': 'Suécia',
  'sg': 'Singapura', 'si': 'Eslovênia', 'sk': 'Eslováquia',
  'sl': 'Serra Leoa', 'sm': 'San Marino', 'sn': 'Senegal',
  'so': 'Somália', 'sr': 'Suriname', 'ss': 'Sudão do Sul',
  'st': 'São Tomé e Príncipe', 'sv': 'El Salvador',
  'sy': 'Síria', 'sz': 'Essuatíni', 'td': 'Chade',
  'tg': 'Togo', 'th': 'Tailândia', 'tj': 'Tadjiquistão',
  'tl': 'Timor-Leste', 'tm': 'Turcomenistão', 'tn': 'Tunísia',
  'to': 'Tonga', 'tr': 'Turquia', 'tt': 'Trinidad e Tobago',
  'tv': 'Tuvalu', 'tw': 'Taiwan', 'tz': 'Tanzânia',
  'ua': 'Ucrânia', 'us': 'Estados Unidos', 'uy': 'Uruguai',
  'uz': 'Uzbequistão', 'va': 'Vaticano', 've': 'Venezuela',
  'vn': 'Vietnã', 'vu': 'Vanuatu', 'ws': 'Samoa',
  'xk': 'Kosovo', 'ye': 'Iêmen', 'za': 'África do Sul',
  'zm': 'Zâmbia', 'zw': 'Zimbábue',
};

// Apenas países que REALMENTE têm arquivo em files/flags/w80/
// (verificado contra os arquivos presentes na pasta)
const List<String> availableCountryCodes = [
  // América Latina
  'br', 'ar', 'bo', 'cl', 'cr', 'cu', 'do', 'ec',
  'gt', 'gy', 'hn', 'ht', 'jm', 'mx', 'ni', 'pa',
  'pe', 'py', 'sr', 'sv', 'tt', 'uy', 've', 'bz',
  // América do Norte
  'ca', 'us',
  // Europa
  'gb', 'es', 'pt', 'nl', 'be', 'ch', 'at',
  'pl', 'se', 'no', 'dk', 'fi', 'ie', 'gr',
  'cz', 'hu', 'ro', 'bg', 'hr', 'sk', 'si',
  'rs', 'lt', 'lv', 'ee', 'lu', 'mc', 'al',
  'ba', 'me', 'mk', 'md', 'by', 'ua', 'am',
  'ge', 'az', 'xk',
  // Ásia / Oceania
  'il', 'au', 'nz', 'tr', 'sa', 'ae', 'eg',
  'th', 'vn', 'id', 'my', 'sg', 'ph', 'pk',
  'bd', 'ir', 'iq', 'in', 'np', 'lk', 'kh',
  'la', 'mm', 'mn', 'kr', 'kp', 'tw', 'hk',
  'qa', 'kw', 'lb', 'jo', 'sy', 'ye', 'om',
  'uz', 'kz', 'kg', 'tj', 'tm', 'af',
  // África
  'za', 'ng', 'ke', 'tz', 'gh', 'ma', 'tn',
  'dz', 'eg', 'et', 'rw', 'ug', 'mz', 'ao',
  'cm', 'ci', 'sn', 'ml', 'bf', 'ne', 'td',
  'sd', 'ss', 'so', 'er', 'dj', 'gn', 'sl',
  'lr', 'gm', 'cv', 'st', 'mw', 'zm', 'zw',
  'na', 'bw', 'ls', 'sz',
];

// Mapa de compatibilidade: nomes antigos → código ISO
// (para documentos cadastrados antes da migração)
const Map<String, String> legacyCountryToIso = {
  'brazil': 'br', 'usa': 'us', 'spain': 'es', 'israel': 'il',
  'canada': 'ca', 'france': 'fr', 'italy': 'it', 'portugal': 'pt',
  'argentina': 'ar', 'peru': 'pe', 'chile': 'cl', 'poland': 'pl',
  'uruguay': 'uy', 'colombia': 'co', 'japan': 'jp', 'russia': 'ru',
  'england': 'gb', 'germany': 'de', 'australia': 'au', 'china': 'cn',
  'mexico': 'mx', 'paraguay': 'py',
};

// Resolve qualquer string de país para caminho de bandeira
String flagAsset(String country) {
  final lower = country.toLowerCase();
  final code = legacyCountryToIso[lower] ?? lower;
  return 'files/flags/w80/$code.png';
}
