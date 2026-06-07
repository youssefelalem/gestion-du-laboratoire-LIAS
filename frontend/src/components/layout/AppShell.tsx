import { Outlet } from 'react-router-dom';
import { Header } from './Header';
import { Sidebar } from './Sidebar';

export function AppShell() {
  return (
    <div className="min-h-screen bg-bg text-ink">
      <Header />
      <div className="grid min-h-[calc(100vh-64px)] grid-cols-[232px_1fr]">
        <Sidebar />
        <main className="min-w-0 overflow-x-auto px-9 pb-16 pt-8">
          <div className="mx-auto max-w-content">
            <Outlet />
          </div>
        </main>
      </div>
    </div>
  );
}
