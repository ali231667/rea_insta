import { z } from 'zod';
import { serviceTypeEnum, vehicleTypeEnum } from '../db/schema.js';

export const zLat = z.coerce.number().min(-90).max(90);
export const zLng = z.coerce.number().min(-180).max(180);
export const zLatLng = z.object({ lat: zLat, lng: zLng });
export const zPoint = zLatLng.extend({ address: z.string().min(1).max(300) });
export const zService = z.enum(serviceTypeEnum.enumValues);
export const zVehicle = z.enum(vehicleTypeEnum.enumValues);
export const zUuid = z.uuid();
