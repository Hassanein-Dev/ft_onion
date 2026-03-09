.PHONY: all up down restart logs url clean fclean re help

GREEN = \033[0;32m
BLUE = \033[0;34m
YELLOW = \033[0;33m
RED = \033[0;31m
NC = \033[0m

all: up url

up:
	@echo "$(BLUE)Building and starting ft_onion service...$(NC)"
	@docker-compose up --build -d
	@echo "$(GREEN)✓ Service is starting...$(NC)"
	@echo "$(YELLOW)Waiting for Tor to generate .onion address (this may take 30-60 seconds)...$(NC)"
	@sleep 5

down:
	@echo "$(YELLOW)Stopping ft_onion service...$(NC)"
	@docker-compose down
	@echo "$(GREEN)✓ Service stopped$(NC)"

restart: down up url

logs:
	@docker-compose logs -f

url:
	@echo "$(BLUE)=========================================$(NC)"
	@echo "$(GREEN)Your .onion address:$(NC)"
	@if [ -n "$$(docker ps -q -f name=ft_onion_service)" ]; then \
		docker exec ft_onion_service cat /var/lib/tor/hidden_service/hostname 2>/dev/null || \
		echo "$(YELLOW)⏳ Address not ready yet. Wait a few seconds and run 'make url' again.$(NC)"; \
	else \
		echo "$(RED)❌ Container is not running. Run 'make up' first.$(NC)"; \
	fi
	@echo "$(BLUE)=========================================$(NC)"

clean:
	@echo "$(YELLOW)Cleaning up containers...$(NC)"
	@docker-compose down
	@echo "$(GREEN)✓ Containers removed (data preserved)$(NC)"

fclean:
	@echo "$(RED)Removing everything (containers, volumes, .onion address)...$(NC)"
	@docker-compose down -v
	@docker system prune -f
	@echo "$(GREEN)✓ Everything cleaned$(NC)"

re: fclean all

help:
	@echo "$(BLUE)ft_onion - Makefile Commands$(NC)"
	@echo ""
	@echo "$(GREEN)make all$(NC)      - Build and start the service (default)"
	@echo "$(GREEN)make up$(NC)       - Build and start the container"
	@echo "$(GREEN)make down$(NC)     - Stop the container"
	@echo "$(GREEN)make restart$(NC)  - Restart the container"
	@echo "$(GREEN)make logs$(NC)     - Show container logs (Ctrl+C to exit)"
	@echo "$(GREEN)make url$(NC)      - Display the .onion address"
	@echo "$(GREEN)make clean$(NC)    - Stop and remove containers (keep data)"
	@echo "$(GREEN)make fclean$(NC)   - Remove everything (containers + volumes)"
	@echo "$(GREEN)make re$(NC)       - Rebuild everything from scratch"
	@echo "$(GREEN)make help$(NC)     - Show this help message"
	@echo ""
	@echo "$(YELLOW)Quick Start:$(NC)"
	@echo "  1. Run: $(GREEN)make$(NC) or $(GREEN)make up$(NC)"
	@echo "  2. Get URL: $(GREEN)make url$(NC)"
	@echo "  3. Open the URL in Tor Browser"
	@echo ""
