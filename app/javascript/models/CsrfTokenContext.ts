import { createContext, useContext } from 'react';

const CsrfTokenContext = createContext('')

export function useCsrfToken() {
    return useContext(CsrfTokenContext)
}

export default CsrfTokenContext
