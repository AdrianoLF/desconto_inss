import apiClient from "./index";

const jsonToParams = (json) => {
    return new URLSearchParams(json).toString();
  };
export const getProponents = (params) => {
    const queryParams = jsonToParams(params) || '';
    return apiClient.get('/proponents?' + queryParams);
  };
  
export const deleteProponent = (id) => apiClient.delete(`/proponents/${id}`);
export const createProponent = (body) => apiClient.post(`/proponents`, body);
