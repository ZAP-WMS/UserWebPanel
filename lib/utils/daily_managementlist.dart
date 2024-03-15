List<String> sfucolumnNames = [
  'sfuNo',
  'fuc',
  'icc',
  'ictc',
  'occ',
  'octc',
  'ec',
  'cg',
  'dl',
  'vi',
  'Add',
  'Delete',
];
List<String> sfucolumnLabelNames = [
  'SFU No',
  'Fuse unit Condition',
  'Incoming Cable Condition',
  'Incoming Cable Termination Condition',
  'Outgoing Cable Condition',
  'Outgoing Cable Termination Condition',
  'Earthing Condition',
  'Cable Glands',
  'Door lock',
  'Voltage Indicator',
  'Add',
  'Delete',
];
List<String> chargercolumnNames = [
  'CN',
  'DC',
  'CGCA',
  'CGCB',
  'CGCCA',
  'CGCCB',
  'dl',
  'ARM',
  'EC',
  'CC',
  'Add',
  'Delete'
];
List<String> chargercolumnLabelNames = [
  'Charger No',
  'Display Condition',
  'A',
  'B',
  'A',
  'B',
  'Door lock',
  'Availability of Rubber mat',
  'Earthing Condition',
  'Charger Cleaness',
  'Add',
  'Delete'
];
List<String> psscolumnNames = [
  'pssNo',
  'pbc',
  'ec',
  'pdl',
  'sgp',
  'wtiTemp',
  'otiTemp',
  'vpiPresence',
  'viMCCb',
  'vr',
  'ar',
  'mccbHandle',
  'Add',
  'Delete',
];
List<String> psscolumnLabelNames = [
  'PSS No',
  'PSS Body Condition',
  'Earthing Condition',
  'PSS Door Lock',
  'SF6 Gas Pressure in RMU ',
  'WTI Temp (Limit-80 °C)',
  'OTI Temp (Limit-85 °C)',
  'VPI in RMU',
  'Voltage indicator in MCCB',
  'Voltmeter Reading',
  'Ammeter Reading',
  'mccbHandle',
  'Add',
  'Delete',
];
List<String> transformercolumnNames = [
  'trNo',
  'pc',
  'ec',
  'ol',
  'oc',
  'wtiTemp',
  'otiTemp',
  'brk',
  'cta',
  'Add',
  'Delete'
];
List<String> transformerLabelNames = [
  'Tr. No',
  'Physical Condition',
  'Earthing Condition',
  'Is there any oil leakage',
  'Oil Level in Conservator (Min 1/3)',
  'WTI Temp (Limit-80 °C)',
  'OTI Temp (Limit-85 °C)',
  'Buckloz Relay knob position',
  'Cleanness in Tr Area',
  'Add',
  'Delete'
];
List<String> rmucolumnNames = [
  'rmuNo',
  'sgp',
  'vpi',
  'crd',
  'rec',
  'arm',
  'cbts',
  'cra',
  'Add',
  'Delete',
];
List<String> rmuLabelNames = [
  'RMU No.',
  'SFG Gas Pressure in RMU',
  'VPI in RMU',
  'Condition of RMU Door',
  'RMU Earthing Condition',
  'Availability of Rubber Mat',
  'Condition of Breaker Tripping switch',
  'Cleanness in RMU Area',
  'Add',
  'Delete',
];
List<String> acdbcolumnNames = [
  'incomerNo',
  'vi',
  'vr',
  'ar',
  'acdbSwitch',
  'mccbHandle',
  'ccb',
  'arm',
  'Add',
  'Delete'
];
List<String> acdbLabelNames = [
  'Incomer No',
  'Voltage indicator',
  'Voltmeter Reading',
  'Ammeter Reading',
  'ACB ON-OFF Switch',
  'MCCB ON/OFF handle',
  'Condition of Capacitor Bank',
  'Availability of Rubber Mat',
  'Add',
  'Delete'
];
List<String> monthlyChargerColumnName = ['cn', 'gun1', 'gun2', 'Add', 'Delete'];

List<String> monthlyLabelColumnName = [
  'Charger No',
  'Gun-1 Reading',
  'Gun-1 Reading',
  'Add',
  'Delete'
];

List<String> monthlyFilterColumnName = ['cn', 'fcd', 'dcgc', 'Add', 'Delete'];

List<String> monthlyFilterLabelColumnName = [
  'Charger No',
  'Filter Cleaning Date',
  'DC Connector Gun Cleaning Date',
  'Add',
  'Delete'
];
