import type { Server } from 'socket.io';

let io: Server | null = null;

export function setIo(server: Server) {
  io = server;
}

/** Each user joins the room "user:<id>" when connected, so we can reach all their devices. */
export const userRoom = (userId: string) => `user:${userId}`;

export function emitToUser(userId: string, event: string, data: unknown) {
  io?.to(userRoom(userId)).emit(event, data);
}

export function emitToUsers(userIds: string[], event: string, data: unknown) {
  if (!io || userIds.length === 0) return;
  io.to(userIds.map(userRoom)).emit(event, data);
}
