import apiClient from './index';

// Endpoints relacionados a "Usuários"
export const getProponents = () => apiClient.get('/proponents');
export const deleteProponent = (id) => apiClient.delete(`/proponents/${id}`);