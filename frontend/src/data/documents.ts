import type { DocumentsTree } from '@/types';

// Archive documentaire — structurée par évènement / série / édition (+ administratif).
export const DOCUMENTS: DocumentsTree = {
  Évènements: {
    'CASA-DATA': {
      '2025 — 7e édition': [
        { name: 'Programme_CASA-DATA_2025.pdf', size: '412 KB', date: '2025-09-01', type: 'pdf', by: 'S. Bennani' },
        { name: 'Demande_financement_2025.pdf', size: '218 KB', date: '2025-06-12', type: 'pdf', by: 'N. Berrada' },
        { name: 'Attestations_participants.pdf', size: '1.2 MB', date: '2025-10-25', type: 'pdf', by: 'Système' },
        { name: 'Rapport_CASA-DATA_2025.docx', size: '178 KB', date: '2025-11-08', type: 'docx', by: 'S. Bennani' },
        { name: 'Actes_compiles.pdf', size: '6.4 MB', date: '2025-12-15', type: 'pdf', by: 'S. Bennani' },
      ],
      '2024 — 6e édition': [
        { name: 'Programme_CASA-DATA_2024.pdf', size: '380 KB', date: '2024-09-04', type: 'pdf', by: 'S. Bennani' },
        { name: 'Rapport_2024.docx', size: '165 KB', date: '2024-11-12', type: 'docx', by: 'N. Berrada' },
        { name: 'Photos_evenement.zip', size: '24 MB', date: '2024-10-25', type: 'zip', by: 'Système' },
      ],
      '2023 — 5e édition': [
        { name: 'Programme_2023.pdf', size: '362 KB', date: '2023-09-02', type: 'pdf', by: 'M. Chraibi' },
        { name: 'Rapport_2023.docx', size: '148 KB', date: '2023-11-15', type: 'docx', by: 'M. Chraibi' },
      ],
    },
    'Journée Doctorants': {
      '2026 — 4e édition': [
        { name: 'Programme_JD_2026.pdf', size: '205 KB', date: '2026-02-20', type: 'pdf', by: 'K. Tazi' },
        { name: 'Liste_communications.xlsx', size: '42 KB', date: '2026-03-08', type: 'xlsx', by: 'K. Tazi' },
        { name: 'Rapport_JD_2026.docx', size: '120 KB', date: '2026-03-20', type: 'docx', by: 'N. Berrada' },
      ],
      '2025 — 3e édition': [
        { name: 'Programme_JD_2025.pdf', size: '198 KB', date: '2025-02-22', type: 'pdf', by: 'K. Tazi' },
        { name: 'Rapport_JD_2025.docx', size: '115 KB', date: '2025-03-20', type: 'docx', by: 'K. Tazi' },
      ],
    },
    'Séminaires NLP': {
      '2025-2026': [
        { name: 'LLM_Darija_slides.pdf', size: '4.8 MB', date: '2025-11-04', type: 'pdf', by: 'O. Lahlou' },
        { name: 'Invitation_Bouzoubaa.pdf', size: '88 KB', date: '2025-10-20', type: 'pdf', by: 'O. Lahlou' },
      ],
    },
  },
  Administratif: {
    Conventions: [
      { name: 'Convention_Casa_Transports_2024.pdf', size: '540 KB', date: '2024-03-15', type: 'pdf', by: 'Y. El Amrani' },
      { name: 'Convention_INRIA_2025.pdf', size: '612 KB', date: '2025-01-20', type: 'pdf', by: 'Y. El Amrani' },
      { name: 'Convention_CNRS_LIPN_2026.pdf', size: '498 KB', date: '2026-02-10', type: 'pdf', by: 'Y. El Amrani' },
    ],
    'Rapports annuels': [
      { name: 'Rapport_LIAS_2024-2025.pdf', size: '3.2 MB', date: '2025-09-28', type: 'pdf', by: 'Y. El Amrani' },
      { name: 'Rapport_LIAS_2023-2024.pdf', size: '2.9 MB', date: '2024-09-25', type: 'pdf', by: 'M. Sefrioui' },
    ],
  },
};
